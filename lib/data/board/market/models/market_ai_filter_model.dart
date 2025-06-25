import 'package:dongsoop/domain/board/market/entities/market_ai_filter_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_ai_filter_model.freezed.dart';
part 'market_ai_filter_model.g.dart';

@freezed
@JsonSerializable()
class MarketAIFilterModel with _$MarketAIFilterModel {
  final String title;
  final String content;

  MarketAIFilterModel({
    required this.title,
    required this.content,
  });

  Map<String, dynamic> toJson() => _$MarketAIFilterModelToJson(this);

  factory MarketAIFilterModel.fromEntity(MarketAIFilterEntity entity) {
    return MarketAIFilterModel(
      title: entity.title,
      content: entity.content,
    );
  }
}
