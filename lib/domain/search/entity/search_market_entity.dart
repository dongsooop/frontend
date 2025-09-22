class SearchMarketEntity {
  final int id;
  final String title;
  final String content;
  final DateTime createdAt;
  final int price;
  final int? contactCount;

  const SearchMarketEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.price,
    this.contactCount,
  });
}
