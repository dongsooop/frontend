enum RestaurantWebViewStatus {
  loading,
  ready,
  unavailable,
  loadFailure,
}

Uri? parseKakaoPlaceUri(String rawUrl) {
  final uri = Uri.tryParse(rawUrl.trim());
  if (uri == null ||
      !(uri.scheme == 'http' || uri.scheme == 'https') ||
      uri.host != 'place.map.kakao.com' ||
      kakaoPlaceId(uri) == null) {
    return null;
  }

  return uri;
}

String? kakaoPlaceId(Uri? uri) {
  if (uri == null || uri.host != 'place.map.kakao.com') return null;

  final segments =
      uri.pathSegments.where((segment) => segment.isNotEmpty).toList();
  if (segments.isEmpty) return null;

  final idIndex = segments.first == 'm' ? 1 : 0;
  if (segments.length <= idIndex) return null;

  final id = segments[idIndex];
  return RegExp(r'^\d+$').hasMatch(id) ? id : null;
}

bool isSameKakaoPlace(Uri initialUri, Uri? candidateUri) {
  final initialId = kakaoPlaceId(initialUri);
  final candidateId = kakaoPlaceId(candidateUri);
  return initialId != null && initialId == candidateId;
}

RestaurantWebViewStatus? classifyRestaurantHttpError({
  required Uri initialUri,
  required Uri? failedUri,
  required int statusCode,
}) {
  if (!isSameKakaoPlace(initialUri, failedUri)) return null;

  if (statusCode == 400 || statusCode == 404 || statusCode == 410) {
    return RestaurantWebViewStatus.unavailable;
  }

  if (statusCode >= 400) {
    return RestaurantWebViewStatus.loadFailure;
  }

  return null;
}
