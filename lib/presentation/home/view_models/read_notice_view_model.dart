import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 읽은 공지의 글 번호를 담아 두는 키.
const String _readNoticeKey = 'read_notice_ids';

/// 남겨 둘 최대 개수.
///
/// 홈은 공지를 세 건만 받고 계속 새것으로 갈리므로 오래된 기록은 다시 쓰이지
/// 않는다. 그대로 두면 목록이 끝없이 길어진다.
const int _maxKeptIds = 200;

/// 읽은 공지.
///
/// 공지 상세는 앱 화면이 아니라 학교 사이트를 띄우는 웹뷰라, 서버는 누가
/// 무엇을 읽었는지 알지 못한다. 그래서 기기에 남긴다 — 앱을 지우거나 폰을
/// 바꾸면 함께 사라진다. 서버가 기억하게 하려면 읽음 기록 API 가 따로 있어야
/// 한다.
///
/// 키는 서버가 주는 `id` 다. 이 값은 학교 공지 링크에서 뽑은 글 번호라
/// 재크롤링해도 바뀌지 않는다. 링크 문자열을 키로 쓰면 학교가 주소 체계를
/// 바꿀 때 기록이 통째로 날아간다.
///
/// `riverpod_generator` 를 쓰지 않는다. 이 저장소의 다른 프로바이더들처럼
/// 손으로 선언해 둔다.
class ReadNoticeNotifier extends StateNotifier<Set<int>> {
  ReadNoticeNotifier() : super(const {}) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_readNoticeKey) ?? const <String>[];

    state = stored.map(int.tryParse).whereType<int>().toSet();
  }

  /// 공지를 열었을 때 기록한다.
  Future<void> markAsRead(int id) async {
    if (state.contains(id)) return;

    final updated = {...state, id};
    state = updated;

    // 글 번호가 클수록 새 공지다. 최근 것부터 남긴다
    final kept = updated.toList()..sort((a, b) => b.compareTo(a));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _readNoticeKey,
      kept.take(_maxKeptIds).map((id) => id.toString()).toList(growable: false),
    );
  }
}

final readNoticeProvider =
    StateNotifierProvider<ReadNoticeNotifier, Set<int>>((ref) {
  return ReadNoticeNotifier();
});
