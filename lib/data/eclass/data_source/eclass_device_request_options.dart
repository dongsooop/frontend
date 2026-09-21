import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/eclass_exception.dart';

Options buildEclassDeviceRequestOptions({
  String? fid,
  String? deviceToken,
}) {
  final normalizedFid = _nonEmpty(fid);
  final normalizedDeviceToken = _nonEmpty(deviceToken);

  if (normalizedFid == null && normalizedDeviceToken == null) {
    throw const EclassDeviceIdentityException();
  }

  return Options(
    headers: {
      if (normalizedFid != null) 'X-Device-Fid': normalizedFid,
      if (normalizedDeviceToken != null)
        'X-Device-Token': normalizedDeviceToken,
    },
  );
}

String? _nonEmpty(String? value) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}
