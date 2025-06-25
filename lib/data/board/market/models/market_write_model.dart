import 'package:dongsoop/domain/board/market/entities/market_write_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_write_model.freezed.dart';
part 'market_write_model.g.dart';

@freezed
@JsonSerializable()
class MarketWriteModel with _$MarketWriteModel {
  final String title;
  final String content;
  final int price;
  final String type;

  MarketWriteModel({
    required this.title,
    required this.content,
    required this.price,
    required this.type,
  });

  Map<String, dynamic> toJson() => _$MarketWriteModelToJson(this);

  factory MarketWriteModel.fromEntity(MarketWriteEntity entity) {
    return MarketWriteModel(
      title: entity.title,
      content: entity.content,
      price: entity.price,
      type: entity.type,
    );
  }
}
