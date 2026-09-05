import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';

/// 좌우로 넘기는 카드 한 줄과 인디케이터.
///
/// 넘길 게 하나뿐이어도 끌리도록 [BouncingScrollPhysics] 를 쓴다.
/// 항목이 많을 때는 점을 전부 늘어놓지 않고 현재 위치만 숫자로 보여준다.
class SwipeDeck extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final ValueChanged<int>? onPageChanged;
  final VoidCallback? onTapItem;
  final int initialPage;
  final double height;

  const SwipeDeck({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.onPageChanged,
    this.onTapItem,
    this.initialPage = 0,
    this.height = 68,
  });

  @override
  State<SwipeDeck> createState() => _SwipeDeckState();
}

class _SwipeDeckState extends State<SwipeDeck> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = _normalizePage(widget.initialPage);
    _controller = PageController(initialPage: _index);
  }

  @override
  void didUpdateWidget(covariant SwipeDeck oldWidget) {
    super.didUpdateWidget(oldWidget);

    final target = _normalizePage(widget.initialPage);
    final currentIsInvalid = _index >= widget.itemCount;

    if (target == _index && !currentIsInvalid) return;

    _index = target;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controller.hasClients) return;
      _controller.jumpToPage(target);
    });
  }

  int _normalizePage(int page) {
    if (widget.itemCount <= 0) return 0;
    return page.clamp(0, widget.itemCount - 1);
  }

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
          height: widget.height,
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
          const SizedBox(height: 10),
          if (widget.itemCount <= 7)
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
            )
          else
            Text(
              '${_index + 1} / ${widget.itemCount}',
              style: const TextStyle(
                fontSize: 11,
                color: ColorStyles.gray5,
                height: 1.2,
              ),
            ),
        ],
      ],
    );
  }
}
