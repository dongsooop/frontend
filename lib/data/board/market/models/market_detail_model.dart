import 'package:dongsoop/domain/board/market/entities/market_detail_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_detail_model.freezed.dart';
part 'market_detail_model.g.dart';

@freezed
@JsonSerializable()
class MarketDetailModel with _$MarketDetailModel {
  final int id;
  final String title;
  final String content;
  final int price;
  final DateTime createdAt;
  final int contactCount;
  final List<String> imageUrlList;
  final String viewType;

  MarketDetailModel({
    required this.id,
    required this.title,
    required this.content,
    required this.price,
    required this.createdAt,
    required this.contactCount,
    required this.imageUrlList,
    required this.viewType,
  });

  factory MarketDetailModel.fromJson(Map<String, dynamic> json) =>
      _$MarketDetailModelFromJson(json);
}

extension MarketDetailModelMapper on MarketDetailModel {
  MarketDetailEntity toEntity() {
    return MarketDetailEntity(
      id: id,
      title: title,
      content: content,
      price: price,
      createdAt: createdAt,
      contactCount: contactCount,
      imageUrlList: imageUrlList,
      viewType: viewType,
    );
  }
}
