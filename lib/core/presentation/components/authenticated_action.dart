import 'package:dongsoop/core/presentation/components/login_required_dialog.dart';
import 'package:flutter/material.dart';

/// 인증이 필요한 UI 액션의 공통 가드.
///
/// 호출부는 인증 여부와 실제 동작만 전달한다. 인증 정책이 바뀌어도
/// 각 화면의 onTap 구현을 반복 수정하지 않도록 한 곳에서 처리한다.
Future<void> runAuthenticatedAction(
  BuildContext context, {
  required bool isAuthenticated,
  required VoidCallback action,
}) async {
  if (!isAuthenticated) {
    await LoginRequiredDialog(context);
    return;
  }

  action();
}
