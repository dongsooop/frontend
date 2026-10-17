import 'dart:async';

import 'package:dongsoop/domain/auth/model/user.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_choice.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_date_message.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_date_request.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_join_info.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';
import 'package:dongsoop/presentation/chat/blind_date/blind_date_detail_screen.dart';
import 'package:dongsoop/presentation/chat/widgets/blind_bubble.dart';
import 'package:dongsoop/presentation/chat/widgets/match_vote_bottom_sheet.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/providers/chat_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';

const _voteIntro = '이제 과팅의 마지막 순서인 사랑의 작대기 시간이에요!';
const _voteOutro = '투표가 끝나면 과팅은 종료되고, 사랑의 작대기가 이어진 경우 알림으로 전달해 드려요!\n'
    '여러분 다음에 다시 만나요~';

void main() {
  setUpAll(() => initializeDateFormatting('ko_KR', null));

  testWidgets('안내를 2초 간격으로 두 번 표시하고 두 번째 안내 3초 후 10초 선택창을 연다', (tester) async {
    final fixture = await _mount(tester);
    fixture.repository.system.add(BlindDateMessage(
      message: '서버 안내',
      memberId: 0,
      name: '동냥이',
      sendAt: DateTime.now(),
      type: 'SYSTEM',
    ));
    await tester.pump();
    fixture.repository.participants.add({52: '익명2', 54: '익명1'});
    await _paintIntro(tester);

    final introBubble = tester.widget<BlindBubble>(find.ancestor(
      of: find.text(_voteIntro),
      matching: find.byType(BlindBubble),
    ));
    expect(introBubble.type, 'SYSTEM');
    expect(introBubble.nickname, '동냥이');
    expect(introBubble.isMe, isFalse);
    expect(fixture.repository.sentMessages, isEmpty);
    expect(find.byType(MatchVoteBottomSheet), findsNothing);
    expect(find.text(_voteOutro), findsNothing);
    await tester.pump(const Duration(milliseconds: 1999));
    expect(find.text(_voteOutro), findsNothing);
    await tester.pump(const Duration(milliseconds: 1));
    await _paintIntro(tester);
    final outroBubble = tester.widget<BlindBubble>(find.ancestor(
      of: find.text(_voteOutro),
      matching: find.byType(BlindBubble),
    ));
    expect(outroBubble.type, 'SYSTEM');
    expect(outroBubble.nickname, '동냥이');
    expect(outroBubble.isMe, isFalse);
    expect(
      fixture.container
          .read(blindDateMessagesProvider)
          .take(2)
          .map((m) => m.message),
      [_voteOutro, _voteIntro],
    );
    await tester.pump(const Duration(milliseconds: 2999));
    expect(find.byType(MatchVoteBottomSheet), findsNothing);

    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump();
    expect(find.byType(MatchVoteBottomSheet), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(fixture.repository.choices, isEmpty);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('익명2'));
    await tester.pump(const Duration(milliseconds: 9699));
    expect(fixture.repository.choices, isEmpty);
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pumpAndSettle();
    expect(fixture.repository.choices.single.targetId, 52);
    expect(fixture.repository.sentMessages, isEmpty);
    await _unmount(tester, fixture);
  });

  testWidgets('참가자 중복 수신은 안내나 타이머와 이미 마친 투표를 다시 시작하지 않는다', (tester) async {
    final fixture = await _mount(tester);
    fixture.repository.participants.add({52: '익명2', 54: '익명1'});
    await _paintIntro(tester);
    await tester.pump(const Duration(milliseconds: 1500));
    fixture.repository.participants.add({52: '익명2', 54: '익명1'});
    await _paintIntro(tester);
    await tester.pump(const Duration(milliseconds: 500));
    await _paintIntro(tester);
    expect(find.text(_voteOutro), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    fixture.repository.participants.add({52: '익명2', 54: '익명1'});
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    expect(find.byType(MatchVoteBottomSheet), findsOneWidget);
    fixture.repository.participants.add({52: '익명2', 54: '익명1'});
    await tester.pump();
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();
    expect(fixture.repository.choices, isEmpty);

    fixture.repository.participants.add({52: '익명2', 54: '익명1'});
    await tester.pump();
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();
    expect(find.byType(MatchVoteBottomSheet), findsNothing);
    expect(fixture.repository.choices, isEmpty);
    expect(
        fixture.container
            .read(blindDateMessagesProvider)
            .where((message) => message.message == _voteIntro),
        hasLength(1));
    expect(
        fixture.container
            .read(blindDateMessagesProvider)
            .where((message) => message.message == _voteOutro),
        hasLength(1));
    await _unmount(tester, fixture);
  });

  for (final showSecondMessage in [false, true]) {
    final stage = showSecondMessage ? '두 번째' : '첫 번째';
    for (final event in ['ended', 'disconnected', 'FAILED', 'TERMINATED']) {
      testWidgets('$stage 안내 중 $event 이벤트가 오면 남은 안내와 선택창 예약을 취소한다',
          (tester) async {
        final fixture = await _mount(tester);
        await _showVoteIntro(tester, fixture.repository,
            showSecondMessage: showSecondMessage);
        await tester.pump(const Duration(milliseconds: 500));
        if (event == 'ended') {
          fixture.repository.ended.add('ended');
        } else if (event == 'disconnected') {
          fixture.repository.disconnected.add('connection closed');
        } else {
          fixture.repository.join.add(BlindJoinInfo(name: '', state: event));
        }
        await tester.pump();
        await tester.pump(const Duration(seconds: 15));
        await tester.pumpAndSettle();
        expect(find.byType(MatchVoteBottomSheet), findsNothing);
        expect(fixture.repository.choices, isEmpty);
        expect(
            fixture.container
                .read(blindDateMessagesProvider)
                .where((message) => message.message == _voteOutro),
            hasLength(showSecondMessage ? 1 : 0));
        expect(tester.takeException(), isNull);
        await _unmount(tester, fixture);
      });
    }
  }

  testWidgets('이전 메시지를 보던 중에도 안내 메시지 위치로 이동한다', (tester) async {
    final fixture = await _mount(tester);
    for (var i = 0; i < 20; i++) {
      fixture.repository.system.add(BlindDateMessage(
        message: '이전 안내 $i',
        memberId: 0,
        name: '동냥이',
        sendAt: DateTime.now(),
        type: 'SYSTEM',
      ));
    }
    await tester.pumpAndSettle();
    final list = tester.widget<ListView>(find.byType(ListView));
    list.controller!.jumpTo(list.controller!.position.maxScrollExtent);
    await tester.pump();
    expect(list.controller!.offset, greaterThan(0));
    fixture.repository.participants.add({52: '익명2', 54: '익명1'});
    await _paintIntro(tester);
    expect(list.controller!.offset, 0);
    expect(find.text(_voteIntro).hitTestable(), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await _paintIntro(tester);
    expect(list.controller!.offset, 0);
    expect(find.text(_voteOutro).hitTestable(), findsOneWidget);
    await _unmount(tester, fixture);
  });

  for (final scenario in [
    (second: false, delay: const Duration(milliseconds: 500)),
    (second: true, delay: const Duration(seconds: 1)),
    (second: true, delay: const Duration(milliseconds: 2990)),
  ]) {
    testWidgets(
        '두 번째 안내 ${scenario.second}, ${scenario.delay.inMilliseconds}ms 뒤 나가도 선택창이 나타나지 않는다',
        (tester) async {
      final fixture = await _mount(tester);
      await _showVoteIntro(tester, fixture.repository,
          showSecondMessage: scenario.second);
      await tester.pump(scenario.delay);
      fixture.router.pop();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 15));
      expect(find.text('과팅 홈'), findsOneWidget);
      expect(find.byType(MatchVoteBottomSheet), findsNothing);
      expect(fixture.repository.choices, isEmpty);
      expect(tester.takeException(), isNull);
      await _unmount(tester, fixture);
    });
  }

  testWidgets('/join maxCount를 대기 화면과 채팅 상단에 표시한다', (tester) async {
    final fixture = await _mount(tester);
    fixture.repository.join.add(
      BlindJoinInfo(
        sessionId: 'waiting-session',
        name: '익명1',
        state: 'WAITING',
        maxCount: 2,
      ),
    );
    fixture.repository.joined.add(1);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('1/2'), findsOneWidget);
    expect(
      fixture.container.read(blindDateDetailViewModelProvider).sessionId,
      'waiting-session',
    );

    fixture.repository.start.add('session');
    await tester.pumpAndSettle();
    expect(find.text('2'), findsOneWidget);
    expect(
      fixture.container.read(blindDateDetailViewModelProvider).sessionId,
      'session',
    );
    await _unmount(tester, fixture);
  });

  testWidgets('/join PROCESSING이면 시작 이벤트 없이 채팅방을 표시한다', (tester) async {
    final fixture = await _mount(tester, emitStart: false);
    expect(find.text('참여자를 모집하고 있어요...'), findsOneWidget);

    fixture.repository.join.add(
      BlindJoinInfo(
        sessionId: 'processing-session',
        name: '익명2',
        state: 'PROCESSING',
        maxCount: 2,
      ),
    );
    fixture.repository.joined.add(2);
    await tester.pump();
    await tester.pumpAndSettle();

    final state = fixture.container.read(blindDateDetailViewModelProvider);
    expect(state.isLoading, isFalse);
    expect(state.nickname, '익명2');
    expect(state.volunteer, 2);
    expect(state.maxCount, 2);
    expect(state.sessionId, 'processing-session');
    expect(find.text('참여자를 모집하고 있어요...'), findsNothing);
    expect(find.text('모여봐요 동숲'), findsOneWidget);
    await _unmount(tester, fixture);
  });

  testWidgets('/join KICKED이면 전송을 차단하고 안내 후 과팅 홈으로 돌아간다', (tester) async {
    final fixture = await _mount(tester, emitStart: false);

    fixture.repository.join.add(
      BlindJoinInfo(name: '', state: 'KICKED'),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    final state = fixture.container.read(blindDateDetailViewModelProvider);
    final viewModel =
        fixture.container.read(blindDateDetailViewModelProvider.notifier);
    expect(state.isKicked, isTrue);
    expect(state.isVoteTime, isFalse);
    expect(find.text('관리자에 의해 퇴장되었습니다.'), findsOneWidget);
    expect(fixture.repository.disconnectCount, 1);
    expect(
      viewModel.send(
        BlindDateRequest(message: '차단되어야 하는 메시지', senderId: 54),
      ),
      isFalse,
    );
    expect(
      await viewModel.choice(BlindChoice(choicerId: 54, targetId: 52)),
      isFalse,
    );
    expect(fixture.repository.sentMessages, isEmpty);
    expect(fixture.repository.choices, isEmpty);

    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();

    expect(find.text('과팅 홈'), findsOneWidget);
    expect(find.byType(BlindDateDetailScreen), findsNothing);
    expect(fixture.repository.disconnectCount, 1);
    expect(tester.takeException(), isNull);
    await _unmount(tester, fixture);
  });

  testWidgets('진행 중 KICKED이면 선택 타이머를 취소하고 한 번만 종료한다', (tester) async {
    final fixture = await _mount(tester);
    await _openVote(tester, fixture.repository);
    await tester.pumpAndSettle();
    await tester.tap(find.text('익명2'));

    fixture.repository.join.add(
      BlindJoinInfo(name: '', state: 'KICKED'),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byType(MatchVoteBottomSheet), findsNothing);
    expect(find.text('관리자에 의해 퇴장되었습니다.'), findsOneWidget);
    expect(fixture.repository.disconnectCount, 1);
    expect(fixture.repository.choices, isEmpty);

    fixture.repository.join.add(
      BlindJoinInfo(name: '', state: 'KICKED'),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 11));

    expect(find.text('관리자에 의해 퇴장되었습니다.'), findsOneWidget);
    expect(fixture.repository.disconnectCount, 1);
    expect(fixture.repository.choices, isEmpty);
    expect(fixture.repository.sentMessages, isEmpty);

    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();
    expect(find.text('과팅 홈'), findsOneWidget);
    expect(fixture.repository.operations, [
      'disconnect',
      'disconnected',
      'pop:blind',
    ]);
    expect(tester.takeException(), isNull);
    await _unmount(tester, fixture);
  });

  testWidgets('추방된 과팅을 종료한 뒤 새 과팅에서는 메시지를 전송할 수 있다', (tester) async {
    final kickedFixture = await _mount(tester, emitStart: false);
    kickedFixture.repository.join.add(
      BlindJoinInfo(name: '', state: 'KICKED'),
    );
    await tester.pump();
    await tester.pumpAndSettle();
    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();
    await _unmount(tester, kickedFixture);

    final nextFixture = await _mount(tester);
    final viewModel =
        nextFixture.container.read(blindDateDetailViewModelProvider.notifier);
    expect(
      viewModel.send(
        BlindDateRequest(message: '새 과팅 메시지', senderId: 54),
      ),
      isTrue,
    );
    expect(nextFixture.repository.sentMessages, hasLength(1));
    expect(nextFixture.repository.sentMessages.single.message, '새 과팅 메시지');
    expect(
      nextFixture.container.read(blindDateDetailViewModelProvider).isKicked,
      isFalse,
    );
    await _unmount(tester, nextFixture);
  });

  testWidgets('새 과팅 연결 시 이전 세션 메시지를 제거한다', (tester) async {
    final fixture = await _mount(
      tester,
      seedMessage: BlindDateMessage(
        messageId: 'old-message',
        message: '이전 세션 메시지',
        memberId: 52,
        name: '익명2',
        sendAt: DateTime(2026, 10, 15, 12),
        type: 'USER',
      ),
    );

    expect(
      fixture.container.read(blindDateMessagesProvider),
      isEmpty,
    );
    expect(find.text('이전 세션 메시지'), findsNothing);
    await _unmount(tester, fixture);
  });

  for (final selectTarget in [false, true]) {
    testWidgets(
        selectTarget
            ? '선택 전송과 연결 종료 후 결과 이벤트 없이 과팅 홈으로 돌아간다'
            : '미선택이면 전송 없이 연결을 종료하고 과팅 홈으로 돌아간다', (tester) async {
      final fixture = await _mount(tester);
      await _openVote(tester, fixture.repository);
      await tester.pumpAndSettle();
      if (selectTarget) await tester.tap(find.text('익명2'));
      await tester.pump(const Duration(seconds: 10));
      await tester.pumpAndSettle();
      if (selectTarget) {
        expect(fixture.repository.choices, hasLength(1));
        expect(fixture.repository.choices.single.targetId, 52);
      } else {
        expect(fixture.repository.choices, isEmpty);
      }
      expect(find.byType(MatchVoteBottomSheet), findsNothing);
      expect(find.byType(BlindDateDetailScreen), findsNothing);
      expect(find.text('사랑의 작대기 성공'), findsNothing);
      expect(find.text('사랑의 작대기 실패'), findsNothing);
      expect(find.text('과팅 홈'), findsOneWidget);
      expect(fixture.repository.operations, [
        if (selectTarget) 'choice',
        'disconnect',
        'disconnected',
        'pop:blind'
      ]);
      expect(fixture.repository.disconnectCount, 1);
      expect(tester.takeException(), isNull);
      await _unmount(tester, fixture);
    });
  }

  testWidgets('연결 종료를 기다리는 중 중복 선택과 참가자를 무시하고 한 번만 나간다', (tester) async {
    final fixture = await _mount(tester);
    final disconnected = Completer<void>();
    fixture.repository.disconnectCompleter = disconnected;
    await _openVote(tester, fixture.repository);
    await tester.pumpAndSettle();
    final viewModel =
        fixture.container.read(blindDateDetailViewModelProvider.notifier);
    await tester.tap(find.text('익명2'));
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();
    expect(fixture.repository.operations, ['choice', 'disconnect']);
    expect(find.byType(BlindDateDetailScreen), findsOneWidget);
    expect(find.byType(MatchVoteBottomSheet), findsNothing);
    fixture.repository.participants.add({52: '익명2', 54: '익명1'});
    expect(await viewModel.choice(BlindChoice(choicerId: 54, targetId: 52)),
        isFalse);
    await tester.pump(const Duration(seconds: 10));
    expect(fixture.repository.choices, hasLength(1));
    disconnected.complete();
    await tester.pumpAndSettle();
    expect(find.text('과팅 홈'), findsOneWidget);
    expect(fixture.repository.operations,
        ['choice', 'disconnect', 'disconnected', 'pop:blind']);
    expect(fixture.repository.disconnectCount, 1);
    expect(await viewModel.choice(BlindChoice(choicerId: 54, targetId: 52)),
        isFalse);
    expect(tester.takeException(), isNull);
    await _unmount(tester, fixture);
  });

  testWidgets('연결 종료 중 사용자가 나가도 다른 화면을 추가로 닫지 않는다', (tester) async {
    final fixture = await _mount(tester);
    final disconnected = Completer<void>();
    fixture.repository.disconnectCompleter = disconnected;
    await _openVote(tester, fixture.repository);
    await tester.pumpAndSettle();
    await tester.tap(find.text('익명2'));
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();
    fixture.router.pop();
    await tester.pumpAndSettle();
    unawaited(fixture.router.push('/other'));
    await tester.pumpAndSettle();
    disconnected.complete();
    await tester.pumpAndSettle();
    expect(find.text('다른 화면'), findsOneWidget);
    expect(find.byType(BlindDateDetailScreen), findsNothing);
    expect(fixture.repository.disconnectCount, 1);
    expect(tester.takeException(), isNull);
    await _unmount(tester, fixture);
  });

  testWidgets('/choice 이후 백그라운드에서 종료되면 복귀 시 과팅 화면을 닫는다', (tester) async {
    final fixture = await _mount(tester);
    final disconnected = Completer<void>();
    fixture.repository.disconnectCompleter = disconnected;
    await _openVote(tester, fixture.repository);
    await tester.pumpAndSettle();
    await tester.tap(find.text('익명2'));
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();
    expect(fixture.repository.operations, ['choice', 'disconnect']);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    disconnected.complete();
    await tester.pump();
    expect(fixture.repository.operations,
        ['choice', 'disconnect', 'disconnected']);
    expect(find.byType(BlindDateDetailScreen), findsOneWidget);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('과팅 홈'), findsOneWidget);
    expect(fixture.repository.operations,
        ['choice', 'disconnect', 'disconnected', 'pop:blind']);
    expect(fixture.repository.disconnectCount, 1);
    expect(tester.takeException(), isNull);
    await _unmount(tester, fixture);
  });

  testWidgets('선택 전송 예외는 안내하고 자동으로 화면을 나가지 않는다', (tester) async {
    final fixture = await _mount(tester);
    fixture.repository.choiceError = StateError('STOMP is not connected');
    await _openVote(tester, fixture.repository);
    await tester.pumpAndSettle();
    await tester.tap(find.text('익명2'));
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();
    expect(fixture.repository.choices, isEmpty);
    expect(fixture.repository.disconnectCount, 0);
    expect(find.byType(BlindDateDetailScreen), findsOneWidget);
    expect(find.text('과팅을 마무리하지 못했어요. 연결 상태를 확인해 주세요.'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await _unmount(tester, fixture);
  });
}

Future<void> _paintIntro(WidgetTester tester) async {
  // Deliver the event, render the message, then paint the scrolled list.
  await tester.pump();
  await tester.pump();
  await tester.pump();
  await tester.pump();
}

Future<void> _showVoteIntro(WidgetTester tester, _Repository repository,
    {bool showSecondMessage = false}) async {
  repository.participants.add({52: '익명2', 54: '익명1'});
  await _paintIntro(tester);
  expect(find.text(_voteIntro), findsOneWidget);
  if (showSecondMessage) {
    await tester.pump(const Duration(seconds: 2));
    await _paintIntro(tester);
    expect(find.text(_voteOutro), findsOneWidget);
  }
}

Future<void> _openVote(WidgetTester tester, _Repository repository) async {
  await _showVoteIntro(tester, repository, showSecondMessage: true);
  await tester.pump(const Duration(seconds: 3));
  await tester.pump();
  expect(find.byType(MatchVoteBottomSheet), findsOneWidget);
}

Future<({ProviderContainer container, _Repository repository, GoRouter router})>
    _mount(
  WidgetTester tester, {
  bool emitStart = true,
  BlindDateMessage? seedMessage,
}) async {
  final repository = _Repository();
  final container = ProviderContainer(overrides: [
    chatRepositoryProvider.overrideWithValue(repository),
    userSessionProvider.overrideWith((ref) => const User(
          id: 54,
          nickname: '테스트',
          departmentType: '',
          role: [],
        )),
  ]);
  final router = GoRouter(initialLocation: '/blind', observers: [
    _NavigationObserver(repository.operations)
  ], routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const Scaffold(body: Text('과팅 홈')),
      routes: [
        GoRoute(
            path: 'blind',
            name: 'blind',
            builder: (context, state) => const BlindDateDetailScreen()),
        GoRoute(
            path: 'other',
            builder: (_, __) => const Scaffold(body: Text('다른 화면'))),
      ],
    ),
  ]);
  if (seedMessage != null) {
    container.read(blindDateMessagesProvider.notifier).addMessage(seedMessage);
  }
  await tester.pumpWidget(UncontrolledProviderScope(
    container: container,
    child: MaterialApp.router(routerConfig: router),
  ));
  await tester.pump();
  if (emitStart) {
    repository.start.add('session');
    await tester.pump();
    await tester.pumpAndSettle();
  } else {
    await tester.pump(const Duration(milliseconds: 100));
  }
  return (container: container, repository: repository, router: router);
}

Future<void> _unmount(
    WidgetTester tester,
    ({
      ProviderContainer container,
      _Repository repository,
      GoRouter router
    }) fixture) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
  fixture.router.dispose();
  fixture.container.dispose();
  await fixture.repository.close();
}

class _NavigationObserver extends NavigatorObserver {
  final List<String> operations;
  _NavigationObserver(this.operations);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name == 'blind') operations.add('pop:blind');
  }
}

class _Repository implements ChatRepository {
  final system = StreamController<BlindDateMessage>.broadcast();
  final ended = StreamController<String>.broadcast();
  final disconnected = StreamController<String>.broadcast();
  final join = StreamController<BlindJoinInfo>.broadcast();
  final joined = StreamController<int>.broadcast();
  final participants = StreamController<Map<int, String>>.broadcast();
  final start = StreamController<String>.broadcast();
  final choices = <BlindChoice>[];
  final sentMessages = <BlindDateRequest>[];
  final operations = <String>[];
  Completer<void>? disconnectCompleter;
  Object? choiceError;
  int disconnectCount = 0;

  @override
  Future<void> blindConnect(int userId) async {}
  @override
  Future<void> blindDisconnect() async {
    disconnectCount++;
    operations.add('disconnect');
    await disconnectCompleter?.future;
    operations.add('disconnected');
  }

  @override
  void choice(BlindChoice data) {
    operations.add('choice');
    final error = choiceError;
    if (error != null) throw error;
    choices.add(data);
  }

  @override
  void blindSendMessage(BlindDateRequest data) => sentMessages.add(data);
  @override
  Stream<Map<int, String>> get participantsStream => participants.stream;
  @override
  Stream<String> get startStream => start.stream;
  @override
  Stream<int> get joinedStream => joined.stream;
  @override
  Stream<BlindJoinInfo> get joinStream => join.stream;
  @override
  Stream<BlindDateMessage> get systemStream => system.stream;
  @override
  Stream<BlindDateMessage> get broadcastStream => const Stream.empty();
  @override
  Stream<bool> get freezeStream => const Stream.empty();
  @override
  Stream<String> get endedStream => ended.stream;
  @override
  Stream<String> get disconnectStream => disconnected.stream;
  Future<void> close() async {
    await system.close();
    await ended.close();
    await disconnected.close();
    await join.close();
    await joined.close();
    await participants.close();
    await start.close();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
