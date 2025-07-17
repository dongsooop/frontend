import 'package:dongsoop/core/presentation/components/common_tag.dart';
import 'package:dongsoop/domain/auth/enum/department_type_ext.dart';
import 'package:dongsoop/presentation/home/view_models/notice_view_model.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeNewNotice extends HookConsumerWidget {
  const HomeNewNotice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userSessionProvider);
    final departmentName = user?.departmentType ?? '';
    final departmentCode =
        DepartmentTypeExtension.fromDisplayName(departmentName).code;
    final department = departmentCode == 'UNKNOWN' ? null : departmentCode;

    final noticeState = ref.watch(noticeViewModelProvider(department));

    useEffect(() {
      Future.microtask(() {
        ref
            .read(noticeViewModelProvider(department).notifier)
            .refresh(departmentType: department);
      });
      return null;
    }, []);

    return Container(
      color: ColorStyles.gray1,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '새로운 공지',
                style: TextStyles.titleTextBold.copyWith(
                  color: ColorStyles.black,
                ),
              ),
              GestureDetector(
                onTap: () => context.goNamed('noticeList'),
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Text(
                        '더보기',
                        style: TextStyles.normalTextRegular.copyWith(
                          color: ColorStyles.gray3,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: ColorStyles.gray3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 공지 카드
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorStyles.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
            child: noticeState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('$err')),
              data: (notices) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(notices.length, (index) {
                    final item = notices[index];
                    final tags =
                        item.isDepartment ? ['학과공지', '학부'] : ['동양공지', '학교생활'];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.pushNamed(
                              'noticeWebView',
                              queryParameters: {'path': item.link},
                            );
                          },
                          child: Text(
                            item.title,
                            style: TextStyles.largeTextBold.copyWith(
                              color: ColorStyles.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          children: tags
                              .asMap()
                              .entries
                              .map((entry) => CommonTag(
                                    label: entry.value,
                                    index: entry.key,
                                  ))
                              .toList(),
                        ),
                        if (index != notices.length - 1)
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 24),
                            width: double.infinity,
                            height: 1,
                            color: ColorStyles.gray2,
                          ),
                      ],
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
