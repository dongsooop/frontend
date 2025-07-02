import 'package:dongsoop/domain/board/market/entities/market_ai_filter_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_ai_filter_model.freezed.dart';
part 'market_ai_filter_model.g.dart';

@freezed
@JsonSerializable()
class MarketAIFilterModel with _$MarketAIFilterModel {
  final String text;

  MarketAIFilterModel({
    required this.text,
  });

  Map<String, dynamic> toJson() => _$MarketAIFilterModelToJson(this);

  factory MarketAIFilterModel.fromEntity(MarketAIFilterEntity entity) {
    return MarketAIFilterModel(text: '${entity.title} | ${entity.content}');
  }
}
