import 'package:dongsoop/core/presentation/components/search_bar.dart';
import 'package:flutter/material.dart';

class SearchBarSection extends StatelessWidget {
  final TextEditingController controller;
  final Future<void> Function(String) onSubmitted;
  final EdgeInsets padding;
  final double hiddenHeight;

  const SearchBarSection({
    super.key,
    required this.controller,
    required this.onSubmitted,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.hiddenHeight = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SearchBarComponent(
        controller: controller,
        onSubmitted: onSubmitted,
      ),
    );
  }
}