import 'package:dongsoop/domain/auth/enum/session_end_reason.dart';

const sanctionedMemberErrorCode = 'SANCTIONED_MEMBER';

SessionEndReason? sessionEndReasonFromResponseData(Object? data) {
  if (data is! Map) return null;

  final code = data['code'] ?? data['errorCode'];
  if (code?.toString().toUpperCase() == sanctionedMemberErrorCode) {
    return SessionEndReason.sanctioned;
  }
  return null;
}

SessionEndReason? sessionEndReasonFromRealtimeError(Object? error) {
  final message = error?.toString().toUpperCase() ?? '';
  if (message.contains(sanctionedMemberErrorCode) ||
      RegExp(r'(^|\D)403(\D|$)').hasMatch(message)) {
    return SessionEndReason.sanctioned;
  }
  if (RegExp(r'(^|\D)401(\D|$)').hasMatch(message)) {
    return SessionEndReason.expired;
  }
  return null;
}
