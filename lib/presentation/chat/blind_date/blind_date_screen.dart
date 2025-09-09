import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BlindDateScreen extends HookConsumerWidget {
  final VoidCallback onTapChat;

  const BlindDateScreen({
    super.key,
    required this.onTapChat,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      backgroundColor: ColorStyles.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 16,
                  children: [
                    _buildTopTab(label: '채팅', isSelected: false, onTap: onTapChat),
                    _buildTopTab(label: '과팅', isSelected: true, onTap: () {},),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 44,
        ),
        child: Center(
          child: Text(
            label,
            style: isSelected
                ? TextStyles.titleTextBold.copyWith(color: ColorStyles.primaryColor,)
                : TextStyles.titleTextRegular.copyWith(color: ColorStyles.gray4),
          ),
        ),
      ),
    );
  }
}