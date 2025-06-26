import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:image_picker/image_picker.dart';

class MarketWriteEntity {
  final String title;
  final String content;
  final int price;
  final MarketType type;
  final List<XFile>? images;

  MarketWriteEntity({
    required this.title,
    required this.content,
    required this.price,
    required this.type,
    this.images,
  });
}
