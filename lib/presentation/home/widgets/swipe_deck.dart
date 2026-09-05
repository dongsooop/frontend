import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';

/// 좌우로 넘기는 카드 한 줄과 점 인디케이터.
///
/// 넘길 게 하나뿐이어도 끌리도록 [BouncingScrollPhysics] 를 쓴다.
/// 끝에서 고무줄처럼 딸려왔다 돌아오면 "여기는 넘기는 곳" 이라는 게 전해지고,
/// 넘길 게 없다는 것도 같이 알려준다. 안내 문구를 따로 두지 않는 이유다.
class SwipeDeck extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final ValueChanged<int>? onPageChanged;
  final VoidCallback? onTapItem;

  const SwipeDeck({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.onPageChanged,
    this.onTapItem,
  });

  @override
  State<SwipeDeck> createState() => _SwipeDeckState();
}

class _SwipeDeckState extends State<SwipeDeck> {
  late final PageController _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 52,
          child: PageView.builder(
            controller: _controller,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.itemCount,
            onPageChanged: (index) {
              setState(() => _index = index);
              widget.onPageChanged?.call(index);
            },
            itemBuilder: (context, index) {
              final child = Align(
                alignment: Alignment.centerLeft,
                child: widget.itemBuilder(context, index),
              );

              if (widget.onTapItem == null) return child;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onTapItem,
                child: child,
              );
            },
          ),
        ),
        if (widget.itemCount > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.itemCount, (i) {
              final isCurrent = i == _index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 2.5),
                width: isCurrent ? 14 : 5,
                height: 5,
                decoration: BoxDecoration(
                  color: isCurrent ? ColorStyles.gray5 : ColorStyles.gray2,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
