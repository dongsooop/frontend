enum ReportAdminFilter {
  unprocessed(
    label: '미처리',
    apiValue: 'UNPROCESSED',
    sort: 'createdAt,asc',
  ),
  activeSanctions(
    label: '활성 제재',
    apiValue: 'ACTIVE_SANCTIONS',
    sort: 'createdAt,desc',
  ),
  processed(
    label: '처리 완료',
    apiValue: 'PROCESSED',
    sort: 'createdAt,asc',
  );

  final String label;
  final String apiValue;
  final String sort;

  const ReportAdminFilter({
    required this.label,
    required this.apiValue,
    required this.sort,
  });
}
