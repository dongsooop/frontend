import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class CommonSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onTap;
  final VoidCallback? onBack;
  final VoidCallback? onClear;
  final String hintText;

  const CommonSearchAppBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onTap,
    this.onBack,
    this.onClear,
    this.hintText = '검색어를 입력해 주세요',
  });

  @override
  Size get preferredSize => const Size.fromHeight(96);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                  visualDensity: VisualDensity.compact,
                  onPressed: onBack ?? () => context.pop(),
                  highlightColor: Colors.transparent,
                  icon: const Icon(
                    Icons.navigate_before,
                    size: 24,
                    color: ColorStyles.black,
                  ),
                ),

                const SizedBox(width: 8),

                SvgPicture.asset(
                  'assets/icons/search.svg',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    ColorStyles.gray4,
                    BlendMode.srcIn,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    onFieldSubmitted: (_) => onTap(),
                    textInputAction: TextInputAction.search,
                    style: TextStyles.normalTextRegular.copyWith(
                      color: ColorStyles.black,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: hintText,
                      hintStyle: TextStyles.normalTextRegular.copyWith(
                        color: ColorStyles.gray4,
                      ),
                    ),
                  ),
                ),

                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, _) {
                    if (value.text.isEmpty) {
                      return const SizedBox(width: 44);
                    }

                    return IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                      onPressed: () {
                        controller.clear();
                        onClear?.call();
                        focusNode.requestFocus();
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                        color: ColorStyles.gray4,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 4,
          color: ColorStyles.gray1,
        ),
      ],
    );
  }
}
