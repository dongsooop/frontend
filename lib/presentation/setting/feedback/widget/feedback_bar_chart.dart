import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class FeedbackBarChart extends StatelessWidget {
  final List<ServiceStat> stats;

  const FeedbackBarChart({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) {
      return Text(
        '아직 수집된 피드백이 없습니다.',
        style: TextStyles.smallTextRegular.copyWith(
          color: ColorStyles.gray4,
        ),
      );
    }

    final maxValue =
    stats.map((e) => e.count).reduce((a, b) => a > b ? a : b);
    final int maxTick = ((maxValue / 10).ceil() * 10).clamp(10, 1000);

    const double labelWidth = 140;
    const double barHeight = 20;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double axisWidth = constraints.maxWidth - labelWidth - 8;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...stats.map((stat) {
              final ratio = stat.count / maxTick;
              final barWidth = axisWidth * ratio;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: labelWidth,
                      child: Text(
                        stat.label,
                        style: TextStyles.smallTextRegular.copyWith(
                          color: ColorStyles.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: ColorStyles.gray1,
                              borderRadius:
                              BorderRadius.circular(barHeight / 2),
                            ),
                          ),
                          Container(
                            height: barHeight,
                            width: barWidth,
                            decoration: BoxDecoration(
                              color: ColorStyles.primaryColor,
                              borderRadius:
                              BorderRadius.circular(barHeight / 2),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '${stat.count}',
                              style: TextStyles.smallTextBold.copyWith(
                                color: ColorStyles.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.only(left: labelWidth + 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (i) {
                  final value = (maxTick / 4 * i).round();
                  return Text(
                    '$value',
                    style: TextStyles.smallTextRegular.copyWith(
                      color: ColorStyles.gray4,
                    ),
                  );
                }),
              ),
            )
          ],
        );
      },
    );
  }
}

class ServiceStat {
  final String label;
  final int count;

  const ServiceStat(this.label, this.count);
}