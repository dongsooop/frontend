import 'package:dongsoop/domain/board/market/entities/market_list_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_list_model.freezed.dart';
part 'market_list_model.g.dart';

@freezed
@JsonSerializable()
class MarketListModel with _$MarketListModel {
  final int id;
  final String title;
  final String content;
  final int price;
  final DateTime createdAt;
  final int contactCount;
  final String? imageUrl;

  const MarketListModel({
    required this.id,
    required this.title,
    required this.content,
    required this.price,
    required this.createdAt,
    required this.contactCount,
    required this.imageUrl,
  });

  factory MarketListModel.fromJson(Map<String, dynamic> json) =>
      _$MarketListModelFromJson(json);
}

extension MarketListModelMapper on MarketListModel {
  MarketListEntity toEntity() {
    return MarketListEntity(
      id: id,
      title: title,
      content: content,
      price: price,
      createdAt: createdAt,
      contactCount: contactCount,
      imageUrl: imageUrl,
    );
  }
}
