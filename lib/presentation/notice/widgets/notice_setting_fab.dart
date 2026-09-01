import 'dart:async';

import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// 공지 목록 우측 하단에서 알림 설정으로 보내는 버튼.
///
/// 학과를 구독하지 않으면 학과 공지가 오지 않고, 키워드를 걸지 않으면 원하지 않는 공지까지
/// 오는데, 두 설정 모두 지금까지 설정 화면 깊숙이 있어 닿기 어려웠다.
/// 공지를 보는 자리에 두어야 알림을 손보게 된다.
///
/// 처음 열릴 때만 잠깐 넓어져 무엇을 고르는 버튼인지 알린 뒤 원형으로 접힌다.
/// 누르면 [키워드]·[학과 구독]이 위로 펼쳐지고, 바깥을 누르거나 목록을 스크롤하면 접힌다.
class NoticeSettingFab extends HookWidget {
  final VoidCallback onTapKeyword;
  final VoidCallback onTapSubscribe;

  /// 목록 스크롤을 감지해 펼친 상태를 접는다.
  final ScrollController scrollController;

  const NoticeSettingFab({
    super.key,
    required this.onTapKeyword,
    required this.onTapSubscribe,
    required this.scrollController,
  });

  static const Duration _hintDuration = Duration(milliseconds: 2600);

  @override
  Widget build(BuildContext context) {
    final isOpen = useState(false);
    final showHint = useState(true);

    // 진입 안내는 한 번만 보여주고 접는다.
    // 화면을 떠난 뒤 값을 건드리지 않도록 타이머를 취소한다
    useEffect(() {
      final timer = Timer(_hintDuration, () => showHint.value = false);
      return timer.cancel;
    }, const []);

    // 목록을 스크롤하면 읽는 데 방해가 되지 않도록 접는다
    useEffect(() {
      void onScroll() {
        if (showHint.value) showHint.value = false;
        if (isOpen.value) isOpen.value = false;
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    return Stack(
      children: [
        if (isOpen.value)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => isOpen.value = false,
              child: Container(color: ColorStyles.black.withValues(alpha: 0.28)),
            ),
          ),
        Positioned(
          right: 16,
          bottom: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              _Action(
                label: '학과 구독',
                icon: Icons.bookmark_outline,
                visible: isOpen.value,
                onTap: () {
                  isOpen.value = false;
                  onTapSubscribe();
                },
              ),
              const SizedBox(height: 12),
              _Action(
                label: '키워드',
                icon: Icons.sell_outlined,
                visible: isOpen.value,
                onTap: () {
                  isOpen.value = false;
                  onTapKeyword();
                },
              ),
              const SizedBox(height: 12),
              _MainButton(
                isOpen: isOpen.value,
                showHint: showHint.value && !isOpen.value,
                onTap: () {
                  showHint.value = false;
                  isOpen.value = !isOpen.value;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MainButton extends StatelessWidget {
  final bool isOpen;
  final bool showHint;
  final VoidCallback onTap;

  const _MainButton({
    required this.isOpen,
    required this.showHint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorStyles.primary100,
      borderRadius: BorderRadius.circular(28),
      elevation: 6,
      shadowColor: ColorStyles.primaryGray,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          height: 56,
          padding: EdgeInsets.only(left: showHint ? 20 : 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                child: showHint
                    ? Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Text(
                          '받을 키워드·학과 고르기',
                          style: TextStyles.normalTextBold.copyWith(
                            color: ColorStyles.white,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              SizedBox(
                width: 56,
                height: 56,
                child: AnimatedRotation(
                  turns: isOpen ? 0.125 : 0,
                  duration: const Duration(milliseconds: 240),
                  child: const Icon(
                    Icons.add,
                    size: 24,
                    color: ColorStyles.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Action extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool visible;
  final VoidCallback onTap;

  const _Action({
    required this.label,
    required this.icon,
    required this.visible,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 180),
        child: AnimatedSlide(
          offset: visible ? Offset.zero : const Offset(0, 0.3),
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: ColorStyles.white,
                borderRadius: BorderRadius.circular(8),
                elevation: 2,
                shadowColor: ColorStyles.primaryGray,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  child: Text(
                    label,
                    style: TextStyles.smallTextBold.copyWith(
                      color: ColorStyles.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Material(
                color: ColorStyles.white,
                shape: const CircleBorder(),
                elevation: 4,
                shadowColor: ColorStyles.primaryGray,
                child: InkWell(
                  onTap: onTap,
                  customBorder: const CircleBorder(),
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: Icon(icon, size: 20, color: ColorStyles.primary100),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
