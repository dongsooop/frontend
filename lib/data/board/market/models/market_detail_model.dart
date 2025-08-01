import 'package:dongsoop/domain/board/market/entities/market_detail_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_detail_model.freezed.dart';
part 'market_detail_model.g.dart';

@freezed
@JsonSerializable()
class MarketDetailModel with _$MarketDetailModel {
  final int id;
  final int authorId;
  final String title;
  final String content;
  final int price;
  final DateTime createdAt;
  final String type;
  final int contactCount;
  final List<String> imageUrlList;
  final String viewType;

  MarketDetailModel({
    required this.id,
    required this.authorId,
    required this.title,
    required this.content,
    required this.price,
    required this.createdAt,
    required this.type,
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
      authorId: authorId,
      title: title,
      content: content,
      price: price,
      createdAt: createdAt,
      type: type,
      contactCount: contactCount,
      imageUrlList: imageUrlList,
      viewType: viewType,
    );
  }
}
