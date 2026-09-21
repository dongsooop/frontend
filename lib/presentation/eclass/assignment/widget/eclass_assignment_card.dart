import 'package:dongsoop/domain/eclass/entity/eclass_assignment_entity.dart';
import 'package:dongsoop/presentation/eclass/assignment/eclass_assignment_formatters.dart';
import 'package:dongsoop/presentation/eclass/assignment/widget/eclass_submission_badge.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class EclassAssignmentCard extends StatelessWidget {
  final EclassAssignmentEntity assignment;
  final VoidCallback onTap;

  const EclassAssignmentCard({
    super.key,
    required this.assignment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColors = eclassDDayColors(assignment.dDay);

    return Material(
      color: ColorStyles.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        key: Key('eclass-assignment-${assignment.id}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 14,
            children: [
              Container(
                width: 56,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: badgeColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  formatEclassDDay(assignment.dDay),
                  style: TextStyles.normalTextBold.copyWith(
                    color: badgeColors.foreground,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            assignment.courseName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.smallTextRegular.copyWith(
                              color: ColorStyles.gray4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _AssignmentTitle(title: assignment.title),
                          const SizedBox(height: 6),
                          Text(
                            formatEclassDueAt(
                              assignment.dueAt,
                              assignment.dDay,
                            ),
                            style: TextStyles.smallTextRegular.copyWith(
                              color: ColorStyles.gray6,
                            ),
                          ),
                          if (_shouldShowCutoff(assignment)) ...[
                            const SizedBox(height: 3),
                            Text(
                              '지각 제출: ${formatEclassDateTime(assignment.cutoffAt!)}까지',
                              style: TextStyles.smallTextRegular.copyWith(
                                color: ColorStyles.gray4,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    EclassSubmissionBadge(
                      submitted: assignment.submitted,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _shouldShowCutoff(EclassAssignmentEntity assignment) {
    final cutoffAt = assignment.cutoffAt;
    return cutoffAt != null && cutoffAt != assignment.dueAt;
  }
}

class _AssignmentTitle extends StatelessWidget {
  final String title;

  const _AssignmentTitle({required this.title});

  static const _iconSize = 16.0;
  static const _iconGap = 4.0;
  static const _maxLines = 2;
  static const _arrow = WidgetSpan(
    alignment: PlaceholderAlignment.middle,
    child: Padding(
      padding: EdgeInsetsDirectional.only(start: _iconGap),
      child: Icon(
        Icons.chevron_right,
        size: _iconSize,
        color: ColorStyles.gray4,
        applyTextScaling: false,
      ),
    ),
  );

  TextSpan _span(String text, TextStyle style) => TextSpan(
        // Keep the arrow on the same line as the final visible character.
        text: '$text\u2060',
        style: style,
        children: const [_arrow],
      );

  @override
  Widget build(BuildContext context) {
    var style = DefaultTextStyle.of(context).style.merge(
          TextStyles.normalTextBold.copyWith(
            color: ColorStyles.black,
            height: 1.35,
          ),
        );
    if (MediaQuery.boldTextOf(context)) {
      style = style.copyWith(fontWeight: FontWeight.bold);
    }
    final textScaler = MediaQuery.textScalerOf(context);
    final iconScale = textScaler.scale(style.fontSize!) / style.fontSize!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: _span(title, style),
          textDirection: Directionality.of(context),
          textScaler: textScaler,
          locale: Localizations.maybeLocaleOf(context),
          maxLines: _maxLines,
        )..setPlaceholderDimensions([
            PlaceholderDimensions(
              size: Size(
                (_iconSize + _iconGap) * iconScale,
                _iconSize * iconScale,
              ),
              alignment: PlaceholderAlignment.middle,
            ),
          ]);

        bool fits(String text) {
          painter.text = _span(text, style);
          painter.layout(maxWidth: constraints.maxWidth);
          return !painter.didExceedMaxLines;
        }

        var visibleTitle = title.trimRight();
        // Measure with the arrow included so ellipsis never hides the arrow.
        if (!fits(visibleTitle)) {
          final characters = visibleTitle.characters.toList();
          var low = 0;
          var high = characters.length;
          while (low < high) {
            final middle = (low + high + 1) ~/ 2;
            final candidate = '${characters.take(middle).join().trimRight()}…';
            if (fits(candidate)) {
              low = middle;
            } else {
              high = middle - 1;
            }
          }
          visibleTitle = '${characters.take(low).join().trimRight()}…';
        }
        painter.dispose();

        return Text.rich(
          _span(visibleTitle, style),
          maxLines: _maxLines,
          overflow: TextOverflow.ellipsis,
          semanticsLabel: title,
        );
      },
    );
  }
}
