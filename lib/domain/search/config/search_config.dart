class SearchConfig {
  final int pageSize;
  final String defaultSort;

  const SearchConfig({
    this.pageSize = 10,
    this.defaultSort = 'createdAt,desc',
  });
}