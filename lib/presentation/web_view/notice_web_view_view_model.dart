import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class NoticeWebViewState {
  final bool isDownloading;
  final String? errorMessage;

  const NoticeWebViewState({
    this.isDownloading = false,
    this.errorMessage,
  });

  NoticeWebViewState copyWith({
    bool? isDownloading,
    String? errorMessage,
  }) {
    return NoticeWebViewState(
      isDownloading: isDownloading ?? this.isDownloading,
      errorMessage: errorMessage,
    );
  }
}

class NoticeWebViewViewModel extends StateNotifier<NoticeWebViewState> {
  NoticeWebViewViewModel() : super(const NoticeWebViewState());

  bool isDownloadUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    final path = uri.path.toLowerCase();

    const extensions = ['.hwp', '.hwpx', '.xls', '.xlsx', '.pdf', '.zip', '.jpg', '.jpeg', '.png'];

    if (extensions.any((ext) => path.endsWith(ext))) {
      return true;
    }

    if (path.endsWith('/download.do')) {
      return true;
    }

    return false;
  }

  Future<XFile?> downloadFile(String url) async {
    if (state.isDownloading) {
      return null;
    }

    state = state.copyWith(isDownloading: true, errorMessage: null);

    try {
      final uri = Uri.parse(url);

      final tempDir = await getTemporaryDirectory();

      String fileName = _extractFileNameFromUrl(uri) ?? 'file';

      final dio = Dio();
      final response = await dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      final cdFileName = _fileNameFromHeaders(response.headers);
      if (cdFileName != null && cdFileName.isNotEmpty) {
        fileName = cdFileName;
      }

      final savePath = p.join(tempDir.path, fileName);
      final file = File(savePath);
      await file.writeAsBytes(response.data ?? []);

      return XFile(file.path);
    } catch (_) {
      state = state.copyWith(
        errorMessage: '파일을 다운로드하던 중 오류가 발생했습니다.',
      );
      return null;
    } finally {
      state = state.copyWith(isDownloading: false);
    }
  }

  String? _extractFileNameFromUrl(Uri uri) {
    if (uri.pathSegments.isEmpty) return null;
    final last = uri.pathSegments.last;
    if (last.toLowerCase().endsWith('.do')) return null;
    if (last.isEmpty) return null;
    return last;
  }

  String? _fileNameFromHeaders(Headers headers) {
    final cd = headers.value('content-disposition');
    if (cd == null) return null;

    final encodedFilenameMatch = RegExp(r"filename\*=(?:UTF-8''|)([^;]+)",
      caseSensitive: false).firstMatch(cd);

    if (encodedFilenameMatch != null) {
      final raw = encodedFilenameMatch.group(1)!.trim().replaceAll('"', '');
      return Uri.decodeFull(raw);
    }

    final filenameMatch = RegExp(r'filename=([^;]+)',
      caseSensitive: false).firstMatch(cd);

    if (filenameMatch != null) {
      final raw = filenameMatch.group(1)!.trim().replaceAll('"', '');
      return Uri.decodeFull(raw);
    }

    return null;
  }
}

final noticeWebViewViewModelProvider = StateNotifierProvider<NoticeWebViewViewModel, NoticeWebViewState>((ref) => NoticeWebViewViewModel());
