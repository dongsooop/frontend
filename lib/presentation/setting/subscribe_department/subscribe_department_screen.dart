import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/domain/auth/enum/department_type.dart';
import 'package:dongsoop/domain/auth/enum/department_type_ext.dart';
import 'package:dongsoop/providers/device_providers.dart';
import 'package:dongsoop/providers/subscribe_department_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 관심 학과 설정 화면. 자기 헤더를 갖는 독립 라우트용이다.
///
/// 헤더를 공유하는 곳(공지 목록 등)에서는 [SubscribeDepartmentView] 를 직접 쓴다.
class SubscribeDepartmentScreen extends StatelessWidget {
  const SubscribeDepartmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: const DetailHeader(
        title: '관심 학과 설정',
        backgroundColor: ColorStyles.white,
      ),
      body: const SubscribeDepartmentView(),
    );
  }
}

/// 다른 화면 안에 끼워 넣는 관심 학과 설정 본문.
class SubscribeDepartmentView extends ConsumerStatefulWidget {
  const SubscribeDepartmentView({super.key});

  @override
  ConsumerState<SubscribeDepartmentView> createState() =>
      _SubscribeDepartmentViewState();
}

class _SubscribeDepartmentViewState extends ConsumerState<SubscribeDepartmentView> {
  static final _departments = DepartmentType.values
      .where((d) => d != DepartmentType.Unknown)
      .toList(growable: false);

  bool _loading = true;
  bool _saving = false;
  String? _error;
  final Set<String> _selectedCodes = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDepartments());
  }

  void _showSnack(String message) {
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyles.normalTextRegular),
        backgroundColor: ColorStyles.gray3,
      ),
    );
  }

  Future<String?> _requireDeviceToken() async {
    final deviceToken = await ref.read(getFcmTokenUseCaseProvider).execute();
    if (deviceToken == null || deviceToken.isEmpty) {
      _showSnack('오류가 발생했어요. 잠시 후 다시 시도해 주세요.');
      return null;
    }
    return deviceToken;
  }

  Future<void> _loadDepartments() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final deviceToken = await _requireDeviceToken();
    if (deviceToken == null) {
      setState(() {
        _loading = false;
        _error = '오류가 발생했어요. 잠시 후 다시 시도해 주세요.';
      });
      return;
    }

    try {
      final codes = await ref
          .read(getSubscribeDepartmentsUseCaseProvider)
          .execute(deviceToken: deviceToken);
      if (!mounted) return;
      setState(() {
        _selectedCodes
          ..clear()
          ..addAll(codes);
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = '구독 중인 학과를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';
      });
    }
  }

  void _toggleDepartment(String code) {
    setState(() {
      if (_selectedCodes.contains(code)) {
        _selectedCodes.remove(code);
      } else {
        _selectedCodes.add(code);
      }
    });
  }

  Future<void> _save() async {
    if (_saving) return;

    final deviceToken = await _requireDeviceToken();
    if (deviceToken == null) return;

    setState(() => _saving = true);
    try {
      final codes = _selectedCodes.toList();
      await ref
          .read(updateSubscribeDepartmentsUseCaseProvider)
          .execute(deviceToken: deviceToken, departmentTypes: codes);

      _showSnack(
        codes.isEmpty
            ? '전체 학과 구독이 해지됐어요'
            : '${codes.length}개 학과 공지 구독이 저장됐어요',
      );
    } catch (e) {
      _showSnack('저장에 실패했어요. 잠시 후 다시 시도해 주세요.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String get _bannerText {
    if (_selectedCodes.isEmpty) {
      return '선택된 학과 없음 · 저장하면 전체 구독이 해지돼요';
    }

    final names = _departments
        .where((d) => _selectedCodes.contains(d.code))
        .map((d) => d.displayName)
        .toList();

    final label = names.length <= 2
        ? names.join(', ')
        : '${names.first} 외 ${names.length - 1}개';

    return '$label · ${names.length}개 학과 구독 중';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(
                '선택한 학과들의 공지 알림을 받아요. 알림 설정에서 "공지" 토글을 켜야 실제로 발송돼요.\n'
                '여러 학과를 중복으로 선택할 수 있어요.',
                style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4),
              ),
            ),
            Expanded(child: _buildBody()),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorStyles.primary100,
                    disabledBackgroundColor: ColorStyles.primary100,
                    foregroundColor: ColorStyles.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: ColorStyles.white,
                          ),
                        )
                      : Text('학과 구독 저장', style: TextStyles.normalTextBold),
                ),
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: ColorStyles.primary100),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            _error!,
            style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 8),
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: ColorStyles.primary5,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            _bannerText,
            style: TextStyles.smallTextBold.copyWith(color: ColorStyles.primary100),
          ),
        ),
        GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.8,
          ),
          itemCount: _departments.length,
          itemBuilder: (context, index) {
            final department = _departments[index];
            final code = department.code;
            final selected = _selectedCodes.contains(code);

            return _DepartmentChip(
              label: department.displayName,
              selected: selected,
              onTap: () => _toggleDepartment(code),
            );
          },
        ),
      ],
    );
  }
}

class _DepartmentChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DepartmentChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? ColorStyles.primary5 : ColorStyles.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? ColorStyles.primary100 : ColorStyles.gray2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 14,
              height: 14,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? ColorStyles.primary100 : ColorStyles.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: selected ? ColorStyles.primary100 : ColorStyles.gray2,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 10, color: ColorStyles.white)
                  : null,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: TextStyles.smallTextRegular.copyWith(
                  color: selected ? ColorStyles.primary100 : ColorStyles.gray6,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
