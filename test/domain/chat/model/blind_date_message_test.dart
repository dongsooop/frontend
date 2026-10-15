import 'package:dongsoop/domain/chat/model/blind_date/blind_date_message.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_join_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('과팅 사용자 메시지에서 신고용 messageId를 보존한다', () {
    final message = BlindDateMessage.fromUserJson({
      'messageId': 'message-17',
      'message': '안녕하세요',
      'senderId': 52,
      'senderName': '익명2',
      'timestamp': 1792036800000,
    });

    expect(message.messageId, 'message-17');
    expect(message.memberId, 52);
    expect(message.type, 'USER');
  });

  test('과팅 입장 정보에서 신고용 sessionId를 보존한다', () {
    final joinInfo = BlindJoinInfo.fromJson({
      'sessionId': 'session-11',
      'name': '익명1',
      'state': 'PROCESSING',
      'maxCount': 4,
    });

    expect(joinInfo.sessionId, 'session-11');
    expect(joinInfo.state, 'PROCESSING');
  });
}
