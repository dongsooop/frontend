import 'package:url_launcher/url_launcher.dart';

const _eclassHost = 'eclass.dongyang.ac.kr';

Uri? parseEclassAssignmentLink(String rawUrl) {
  final value = rawUrl.trim();
  if (value.isEmpty) return null;

  final uri = Uri.tryParse(value);
  if (uri == null ||
      uri.scheme.toLowerCase() != 'https' ||
      uri.host.toLowerCase() != _eclassHost) {
    return null;
  }

  return uri;
}

Future<bool> openEclassAssignmentLink(String rawUrl) async {
  final uri = parseEclassAssignmentLink(rawUrl);
  if (uri == null) return false;

  try {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
}
