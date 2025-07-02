class MarketDetailEntity {
  final int id;
  final String title;
  final String content;
  final int price;
  final DateTime createdAt;
  final String type;
  final int contactCount;
  final List<String> imageUrlList;
  final String viewType;

  MarketDetailEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.price,
    required this.createdAt,
    required this.type,
    required this.contactCount,
    required this.imageUrlList,
    required this.viewType,
  });
}
