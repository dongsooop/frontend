import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';

class WriteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const WriteButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          backgroundColor: ColorStyles.primary100,
          onPressed: onPressed,
          shape: const CircleBorder(),
          child: Icon(
            Icons.add,
            color: ColorStyles.white,
            size: 30.00,
          ),
        ),
      ),
    );
  }
}
