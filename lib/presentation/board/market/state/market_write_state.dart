import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:image_picker/image_picker.dart';

class MarketFormState {
  final String title;
  final String content;
  final int price;
  final List<XFile> images;
  final MarketType? type;
  final bool isSubmitting;
  final String? errorMessage;
  final String? profanityMessage;

  const MarketFormState({
    this.title = '',
    this.content = '',
    this.price = 0,
    this.images = const [],
    this.type,
    this.isSubmitting = false,
    this.errorMessage,
    this.profanityMessage,
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
    );
  }

  bool get isValid =>
      title.trim().isNotEmpty &&
      content.trim().isNotEmpty &&
      price > 0 &&
      type != null;
}
