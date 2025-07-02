class MarketListEntity {
  final int id;
  final String title;
  final String content;
  final int price;
  final DateTime createdAt;
  final int contactCount;
  final String? imageUrl;

  const MarketListEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.price,
    required this.createdAt,
    required this.contactCount,
    required this.imageUrl,
  });
}
