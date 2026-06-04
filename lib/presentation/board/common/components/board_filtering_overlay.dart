import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class BoardFilteringOverlay extends StatelessWidget {
  const BoardFilteringOverlay({super.key});

  static const _widthFactor  = 0.6;
  static const _heightFactor = 0.15;
  static const _elevation    = 8.0;
  static const _radius       = 8.0;

  @override
  Widget build(BuildContext context) {
    final barrier = Colors.black.withAlpha((255 * 0.4).round());

    return Stack(
      children: [
        ModalBarrier(dismissible: false, color: barrier),
        SafeArea(
          child: Center(
            child: FractionallySizedBox(
              widthFactor: _widthFactor,
              heightFactor: _heightFactor,
              child: Material(
                elevation: _elevation,
                color: ColorStyles.white,
                borderRadius: BorderRadius.circular(_radius),
                clipBehavior: Clip.antiAlias,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: ColorStyles.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '비속어 검사 중..',
                          textAlign: TextAlign.center,
                          style: TextStyles.normalTextRegular.copyWith(
                            color: ColorStyles.gray4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

OverlayEntry showBoardFilteringOverlay(
    BuildContext context, {
      bool useRootOverlay = true,
    }) {
  final entry = OverlayEntry(builder: (_) => const BoardFilteringOverlay());
  final overlay = Overlay.of(context, rootOverlay: useRootOverlay);
  overlay.insert(entry);
  return entry;
}

void hideBoardFilteringOverlay(OverlayEntry? entry) {
  try {
    entry?.remove();
  } catch (_) {}
}
