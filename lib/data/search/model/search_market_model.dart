import 'package:dongsoop/domain/search/entity/search_market_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_market_model.freezed.dart';
part 'search_market_model.g.dart';

@freezed
@JsonSerializable()
class SearchMarketModel with _$SearchMarketModel {
  final int boardId;
  final String title;
  final String content;
  final DateTime createdAt;
  final int price;
  final int contactCount;

  SearchMarketModel({
    required this.boardId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.price,
    required this.contactCount,
  });

  factory SearchMarketModel.fromJson(Map<String, dynamic> json) => _$SearchMarketModelFromJson(json);
}

extension SearchMarketModelMapper on SearchMarketModel {
  SearchMarketEntity toEntity() {
    return SearchMarketEntity(
      id: boardId,
      title: title,
      content: content,
      createdAt: createdAt,
      price: price,
      contactCount: contactCount
    );
  }
}
