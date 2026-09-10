import 'package:dongsoop/core/presentation/components/admob_native_ad.dart';
import 'package:dongsoop/providers/read_notice_provider.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class CommonNoticeList<T> extends StatelessWidget {
  const CommonNoticeList({
    super.key,
    required this.items,
    required this.controller,
    required this.isLoading,
    required this.hasMore,
    required this.titleOf,
    required this.isDepartmentOf,
    required this.onTap,
    this.idOf,
    this.createdAtOf,
    this.onReminder,
    this.showSwipeHint = false,
  });

  final List<T> items;
  final ScrollController controller;
  final bool isLoading;
  final bool hasMore;
  final String Function(T) titleOf;
  final bool Function(T) isDepartmentOf;
  final void Function(T) onTap;
  final int Function(T)? idOf;
  final DateTime Function(T)? createdAtOf;
  final void Function(T)? onReminder;
  final bool showSwipeHint;

  @override
  Widget build(BuildContext context) {
    const adInterval = 10;

    return ListView.builder(
      controller: controller,
      itemCount: items.length + (items.length ~/ adInterval) + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index > 0 && index % (adInterval + 1) == adInterval) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: AdmobNativeAd(),
          );
        }

        final int adCount = index ~/ (adInterval + 1);
        final int actualIndex = index - adCount;

        if (actualIndex == items.length) {
          return isLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ColorStyles.primaryColor,
                    ),
                  ),
                )
              : const SizedBox.shrink();
        }

        final item = items[actualIndex];
        final idGetter = idOf;
        final createdAtGetter = createdAtOf;
        final reminderCallback = onReminder;

        return CommonNoticeListItem(
          title: titleOf(item),
          isDepartment: isDepartmentOf(item),
          noticeId: idGetter == null ? null : idGetter(item),
          createdAt: createdAtGetter == null ? null : createdAtGetter(item),
          onTap: () => onTap(item),
          onReminder:
              reminderCallback == null ? null : () => reminderCallback(item),
          showSwipeHint: showSwipeHint && actualIndex == 0,
          isLastItem: actualIndex == items.length - 1,
        );
      },
    );
  }
}

class CommonNoticeListItem extends ConsumerStatefulWidget {
  const CommonNoticeListItem({
    super.key,
    required this.title,
    required this.isDepartment,
    required this.onTap,
    required this.isLastItem,
    this.noticeId,
    this.createdAt,
    this.onReminder,
    this.showSwipeHint = false,
  });

  final String title;
  final bool isDepartment;
  final VoidCallback onTap;
  final bool isLastItem;
  final int? noticeId;
  final DateTime? createdAt;
  final VoidCallback? onReminder;
  final bool showSwipeHint;

  @override
  ConsumerState<CommonNoticeListItem> createState() =>
      _CommonNoticeListItemState();
}

class _CommonNoticeListItemState extends ConsumerState<CommonNoticeListItem> {
  static const double _actionSize = 64;
  static const double _revealThreshold = 32;

  double _offset = 0;
  bool _isDragging = false;
  bool _revealHapticPlayed = false;
  bool _fullHapticPlayed = false;

  @override
  void initState() {
    super.initState();

    if (widget.showSwipeHint && widget.onReminder != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _playSwipeHint());
    }
  }

  @override
  void didUpdateWidget(covariant CommonNoticeListItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.showSwipeHint &&
        widget.showSwipeHint &&
        widget.onReminder != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _playSwipeHint());
    }
  }

  Future<void> _playSwipeHint() async {
    if (!mounted || _isDragging) return;

    setState(() => _offset = 12);
    await Future<void>.delayed(const Duration(milliseconds: 260));
    if (!mounted || _isDragging) return;
    setState(() => _offset = 0);
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    if (widget.onReminder == null) return;

    _isDragging = true;
    _revealHapticPlayed = _offset >= _actionSize;
    _fullHapticPlayed = false;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (widget.onReminder == null) return;

    final width = context.size?.width ?? MediaQuery.sizeOf(context).width;
    final maxOffset = width * 0.6;
    final fullThreshold = width * 0.45;

    final next = (_offset - details.delta.dx).clamp(0.0, maxOffset);

    if (!_revealHapticPlayed && next >= _actionSize) {
      _revealHapticPlayed = true;
      HapticFeedback.selectionClick();
    }

    if (!_fullHapticPlayed && next >= fullThreshold) {
      _fullHapticPlayed = true;
      HapticFeedback.mediumImpact();
    }

    setState(() => _offset = next);
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (widget.onReminder == null) return;

    final width = context.size?.width ?? MediaQuery.sizeOf(context).width;
    final fullThreshold = width * 0.45;
    final shouldOpenReminder = _offset >= fullThreshold;

    _isDragging = false;
    setState(() {
      _offset = shouldOpenReminder
          ? 0
          : (_offset >= _revealThreshold ? _actionSize : 0);
    });

    if (shouldOpenReminder) {
      widget.onReminder?.call();
    }
  }

  void _onTapItem() {
    if (_offset > 0) {
      setState(() => _offset = 0);
      return;
    }

    final id = widget.noticeId;
    if (id != null) {
      ref.read(readNoticeProvider.notifier).markAsRead(id);
    }
    widget.onTap();
  }

  void _onTapReminder() {
    setState(() => _offset = 0);
    widget.onReminder?.call();
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.noticeId;
    final isRead = id != null && ref.watch(readNoticeProvider).contains(id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showSwipeHint && widget.onReminder != null)
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: ColorStyles.gray1,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.swipe_left_rounded,
                  size: 18,
                  color: ColorStyles.gray5,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '공지를 왼쪽으로 밀어 리마인더를 설정할 수 있어요.',
                    style: TextStyles.smallTextRegular.copyWith(
                      color: ColorStyles.gray5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ClipRect(
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              if (widget.onReminder != null)
                const Positioned.fill(
                  child: ColoredBox(
                    color: ColorStyles.primary100,
                  ),
                ),
              if (widget.onReminder != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: _actionSize,
                    height: _actionSize,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _onTapReminder,
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: ColorStyles.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              AnimatedContainer(
                duration: _isDragging
                    ? Duration.zero
                    : const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                transform: Matrix4.translationValues(-_offset, 0, 0),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _onTapItem,
                  onHorizontalDragStart: widget.onReminder == null
                      ? null
                      : _onHorizontalDragStart,
                  onHorizontalDragUpdate: widget.onReminder == null
                      ? null
                      : _onHorizontalDragUpdate,
                  onHorizontalDragEnd:
                      widget.onReminder == null ? null : _onHorizontalDragEnd,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: ColorStyles.white,
                      border: widget.isLastItem
                          ? null
                          : const Border(
                              bottom: BorderSide(
                                color: ColorStyles.gray1,
                                width: 1,
                              ),
                            ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            color: isRead
                                ? ColorStyles.gray2
                                : ColorStyles.primary100,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.largeTextBold.copyWith(
                                  color: ColorStyles.black,
                                  height: 1.45,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _meta(),
                                style: TextStyles.smallTextRegular.copyWith(
                                  color: ColorStyles.gray5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _meta() {
    final source = widget.isDepartment ? '학과공지' : '동양공지';
    final date = widget.createdAt;
    if (date == null) return source;

    return '$source · ${_dateLabel(date)}';
  }

  String _dateLabel(DateTime date) {
    final now = DateTime.now();
    if (date.year != now.year) {
      return DateFormat('yyyy년 M월 d일', 'ko').format(date);
    }
    return DateFormat('M월 d일', 'ko').format(date);
  }
}
