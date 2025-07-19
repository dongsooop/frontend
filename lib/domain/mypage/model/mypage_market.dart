import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mypage_market.freezed.dart';
part 'mypage_market.g.dart';

@freezed
@JsonSerializable()
class MypageMarket with _$MypageMarket {
  final int id;
  final String title;
  final String content;
  final int price;
  final DateTime createdAt;
  final int contactCount;
  final String? imageUrl;
  final MarketType type;
  final String status;

  const MypageMarket({
    required this.id,
    required this.title,
    required this.content,
    required this.price,
    required this.createdAt,
    required this.contactCount,
    this.imageUrl,
    required this.type,
    required this.status,
  });

  Map<String, dynamic> toJson() => _$MypageMarketToJson(this);
  factory MypageMarket.fromJson(Map<String, dynamic> json) => _$MypageMarketFromJson(json);
}