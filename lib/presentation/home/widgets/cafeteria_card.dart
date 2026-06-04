import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class CafeteriaCard extends StatefulWidget {
  const CafeteriaCard({
    super.key,
    required this.initialDayIndex,
    required this.todayIndex,
    required this.dayLabels,
    required this.menuByDay,
    this.isLoading = false,
    this.errorText,
  });

  final int initialDayIndex;
  final int todayIndex;
  final List<String> dayLabels;
  final List<String> menuByDay;
  final bool isLoading;
  final String? errorText;

  @override
  State<CafeteriaCard> createState() => _CafeteriaCardState();
}

class _CafeteriaCardState extends State<CafeteriaCard> {
  PageController? _controller;
  int _index = 0;
  int _virtualIndex = 0;

  int get _len => widget.menuByDay.length;
  bool get _hasPages => _len > 0;
  bool get _isInteractive => _hasPages && !widget.isLoading && widget.errorText == null;

  @override
  void initState() {
    super.initState();
    _setupController();
  }

  @override
  void didUpdateWidget(covariant CafeteriaCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.menuByDay.length != widget.menuByDay.length ||
        oldWidget.initialDayIndex != widget.initialDayIndex) {
      _setupController();
    }
  }

  void _setupController() {
    if (_hasPages) {
      final upper = _len - 1;
      final safeInitial = widget.initialDayIndex.clamp(0, upper);
      _index = safeInitial;

      final base = 1000 * _len;
      _virtualIndex = base + safeInitial;

      _controller?.dispose();
      _controller = PageController(initialPage: _virtualIndex);
    } else {
      _index = 0;
      _virtualIndex = 0;
      _controller?.dispose();
      _controller = null;
    }
    setState(() {});
  }

  void _prev() {
    if (!_isInteractive) return;
    if (_controller?.hasClients != true) return;
    _virtualIndex--;
    _controller!.animateToPage(
      _virtualIndex,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );

    _index = ((_virtualIndex % _len) + _len) % _len;
    setState(() {});
  }

  void _next() {
    if (!_isInteractive) return;
    if (_controller?.hasClients != true) return;
    _virtualIndex++;
    _controller!.animateToPage(
      _virtualIndex,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );

    _index = _virtualIndex % _len;
    setState(() {});
  }

  String _titleFor(int page) {
    if (page == widget.todayIndex) return '오늘의 학식';
    final label = (page >= 0 && page < widget.dayLabels.length)
        ? widget.dayLabels[page]
        : '';
    return '$label요일 학식';
  }

  @override
  Widget build(BuildContext context) {
    final leftEnabled = _isInteractive;
    final rightEnabled = _isInteractive;

    String bodyText;
    if (widget.isLoading) {
      bodyText = '불러오는 중...';
    } else if (widget.errorText != null) {
      bodyText = widget.errorText!;
    } else if (!_hasPages) {
      bodyText = '학식이 제공되지 않아요!';
    } else {
      bodyText = widget.menuByDay[_index];
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorStyles.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24,
            child: Row(
              children: [
                _ArrowButton(
                  alignment: Alignment.centerLeft,
                  onTap: leftEnabled ? _prev : null,
                  icon: Icons.chevron_left,
                ),
                 Text(
                    _titleFor(_index),
                    style: TextStyles.normalTextBold.copyWith(color: ColorStyles.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                _ArrowButton(
                  alignment: Alignment.centerRight,
                  onTap: rightEnabled ? _next : null,
                  icon: Icons.chevron_right,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          if (_hasPages && !widget.isLoading && widget.errorText == null)
            SizedBox(
              height: 44,
              child: PageView.builder(
                controller: _controller,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (i) {
                  _virtualIndex = i;
                  _index = i % _len;
                  setState(() {});
                },
                itemBuilder: (_, i) {
                  final real = i % _len;
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.menuByDay[real],
                      style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
            )
          else
            SizedBox(
              height: 44,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  bodyText,
                  style: TextStyles.smallTextRegular.copyWith(
                    color: ColorStyles.gray4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    required this.onTap,
    required this.icon,
    required this.alignment,
  });

  final VoidCallback? onTap;
  final IconData icon;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final Color base = ColorStyles.gray3;
    final Color color = enabled ? base : base.withValues(alpha: 0.8);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: enabled ? onTap : null,
      child: SizedBox(
        width: 44,
        child: IgnorePointer(
          ignoring: !enabled,
          child: Align(
            alignment: alignment,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: enabled ? 1.0 : 0.8,
              child: Icon(icon, size: 24, color: color),
            ),
          ),
        ),
      ),
    );
  }
}

