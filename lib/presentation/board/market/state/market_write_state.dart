import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class MarketFormState {
  final String title;
  final String content;
  final int price;
  final List<XFile> images;
  final MarketType? type;
  final bool isSubmitting;
  final String? errorMessage;
  final String? profanityMessage;
  final int profanityMessageTriggerKey;
  final bool isEditing;
  final int? marketId;
  final List<String> initialImageUrls;
  final String? priceErrorText;

  static const int maxPrice = 9999999;

  const MarketFormState({
    this.title = '',
    this.content = '',
    this.price = 0,
    this.images = const [],
    this.type,
    this.isSubmitting = false,
    this.errorMessage,
    this.profanityMessage,
    this.profanityMessageTriggerKey = 0,
    this.isEditing = false,
    this.marketId,
    this.initialImageUrls = const [],
    this.priceErrorText,
  });

  MarketFormState copyWith({
    String? title,
    String? content,
    int? price,
    List<XFile>? images,
    MarketType? type,
    bool? isSubmitting,
    String? errorMessage,
    String? profanityMessage,
    int? profanityMessageTriggerKey,
    bool? isEditing,
    int? marketId,
    List<String>? initialImageUrls,
    String? priceErrorText,
  }) {
    return MarketFormState(
      title: title ?? this.title,
      content: content ?? this.content,
      price: price ?? this.price,
      images: images ?? this.images,
      type: type ?? this.type,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
      profanityMessage: profanityMessage ?? this.profanityMessage,
      profanityMessageTriggerKey:
          profanityMessageTriggerKey ?? this.profanityMessageTriggerKey,
      isEditing: isEditing ?? this.isEditing,
      marketId: marketId ?? this.marketId,
      initialImageUrls: initialImageUrls ?? this.initialImageUrls,
      priceErrorText: priceErrorText,
    );
  }

  bool get isValid =>
      title.trim().isNotEmpty &&
      content.trim().isNotEmpty &&
      price > 0 &&
      price <= maxPrice &&
      type != null;
}
