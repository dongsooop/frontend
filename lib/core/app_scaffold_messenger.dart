import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();

void showRootSnack(String message) {
  final messenger = rootScaffoldMessengerKey.currentState;
  if (messenger == null) {
    return;
  }
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.white),
      ),
      backgroundColor: ColorStyles.black,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    ),
  );
}