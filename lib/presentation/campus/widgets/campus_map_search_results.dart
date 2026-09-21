import 'package:dongsoop/presentation/campus/widgets/campus_map_search.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class CampusMapSearchResults extends StatelessWidget {
  const CampusMapSearchResults({
    super.key,
    required this.results,
    required this.onSelect,
  });

  final List<CampusMapSearchResult> results;
  final ValueChanged<CampusMapSearchResult> onSelect;

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 32),
          const Icon(Icons.search_off, size: 32, color: ColorStyles.gray5),
          const SizedBox(height: 16),
          Text(
            '일치하는 시설이 없어요',
            textAlign: TextAlign.center,
            style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
          ),
          const SizedBox(height: 8),
          Text(
            '건물이나 시설 이름으로 다시 검색해 보세요.',
            textAlign: TextAlign.center,
            style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
          ),
        ],
      );
    }

    final buildings = <String, List<CampusMapSearchResult>>{};
    final areas = <CampusMapSearchResult>[];
    for (final result in results) {
      if (result.building case final building?) {
        (buildings[building.id] ??= []).add(result);
      } else {
        areas.add(result);
      }
    }
    final floorCount = results.where((result) => result.floor != null).length;
    final summary = [
      if (buildings.isNotEmpty) '${buildings.length}개 건물',
      if (floorCount > 0) '$floorCount개 층',
      if (areas.isNotEmpty) '흡연구역 ${areas.length}곳',
    ].join(' · ');

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Semantics(
          liveRegion: true,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Wrap(
              spacing: 12,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  '검색 결과',
                    style: TextStyles.normalTextBold.copyWith(color: ColorStyles.black)
                ),
                Text(
                  summary,
                  style: TextStyles.smallTextRegular.copyWith(
                    color: ColorStyles.gray4,
                  ),
                ),
              ],
            ),
          ),
        ),
        for (final group in buildings.values)
          _BuildingResults(results: group, onSelect: onSelect),
        for (final result in areas)
          Column(
            children: [
              const Divider(height: 1, color: ColorStyles.gray2),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                leading: const Icon(Icons.smoking_rooms, size: 24, color: ColorStyles.labelColorYellow100),
                title: Text(result.location, style: TextStyles.normalTextBold.copyWith(
                  color: ColorStyles.black,
                )),
                subtitle: Text(
                  result.smokingArea!.location,
                  style: TextStyles.smallTextRegular.copyWith(
                    color: ColorStyles.gray4,
                  ),
                ),
                trailing:
                const Icon(Icons.chevron_right, size: 24, color: ColorStyles.gray5),
                onTap: () => onSelect(result),
              ),
            ],
          ),
      ],
    );
  }
}

class _BuildingResults extends StatelessWidget {
  const _BuildingResults({required this.results, required this.onSelect});

  final List<CampusMapSearchResult> results;
  final ValueChanged<CampusMapSearchResult> onSelect;

  @override
  Widget build(BuildContext context) {
    final building = results.first.building!;
    if (results.first.floor == null) {
      return Column(
        children: [
          const Divider(height: 1, color: ColorStyles.gray2),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            leading: const Icon(Icons.apartment_outlined, size: 24, color: ColorStyles.primary100),
            title: Text(building.name, style: TextStyles.normalTextBold.copyWith(color: ColorStyles.black)),
            subtitle: Text('캠퍼스 맵에서 보기', style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray6)),
            trailing: const Icon(Icons.chevron_right, size: 24, color: ColorStyles.gray5),
            onTap: () => onSelect(results.first),
          ),
        ],
      );
    }

    // 넓은 검색어(예: Lab)에도 어떤 시설이 어느 층에 있는지 알 수 있다.
    final facilities = <String, List<CampusMapSearchResult>>{};
    for (final result in results) {
      (facilities[result.facilities.join(' · ')] ??= []).add(result);
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: ColorStyles.gray2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  building.name,
                  style: TextStyles.normalTextBold.copyWith(color: ColorStyles.black),
                ),
              ),
              Text(
                '${results.length}개 층',
                style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4),
              ),
            ],
          ),
          for (final entry in facilities.entries) ...[
            const SizedBox(height: 8),
            Text(
              entry.key,
              style: TextStyles.smallTextRegular.copyWith(
                color: ColorStyles.gray4,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final result in entry.value)
                  Semantics(
                    label: '${result.location}, ${entry.key}',
                    button: true,
                    onTap: () => onSelect(result),
                    excludeSemantics: true,
                    child: OutlinedButton(
                      key: ValueKey(
                          'campus-search-${building.id}-${result.floor!.name}'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColorStyles.primary100,
                        minimumSize: const Size(40, 40),
                        side: const BorderSide(color: ColorStyles.gray2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => onSelect(result),
                      child: Text(
                        result.floor!.name,
                        style: TextStyles.smallTextBold.copyWith(
                          color: ColorStyles.primaryColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
