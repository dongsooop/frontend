import 'dart:io';

import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/board/market/entities/market_ai_filter_entity.dart';
import 'package:dongsoop/domain/board/market/entities/market_write_entity.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/domain/board/market/use_cases/market_ai_filter_use_case.dart';
import 'package:dongsoop/domain/board/market/use_cases/market_detail_use_case.dart';
import 'package:dongsoop/domain/board/market/use_cases/market_update_use_case.dart';
import 'package:dongsoop/domain/board/market/use_cases/market_write_use_case.dart';
import 'package:dongsoop/presentation/board/market/state/market_write_state.dart';
import 'package:dongsoop/presentation/board/providers/market/market_ai_filter_use_case_provider.dart';
import 'package:dongsoop/presentation/board/providers/market/market_detail_use_case_provider.dart';
import 'package:dongsoop/presentation/board/providers/market/market_update_use_case_provider.dart';
import 'package:dongsoop/presentation/board/providers/market/market_write_use_case_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'market_write_view_model.g.dart';

@riverpod
class MarketWriteViewModel extends _$MarketWriteViewModel {
  MarketWriteUseCase get _writeUseCase => ref.watch(marketWriteUseCaseProvider);
  MarketUpdateUseCase get _updateUseCase =>
      ref.watch(marketUpdateUseCaseProvider);
  MarketAIFilterUseCase get _aiFilterUseCase =>
      ref.watch(marketAiFilterUseCaseProvider);
  MarketDetailUseCase get _detailUseCase =>
      ref.watch(marketDetailUseCaseProvider);
  bool _submitting = false;
  bool _loadingDetail = false;
  bool _compressing = false;

  @override
  MarketFormState build({required bool isEditing, int? marketId}) {
    if (isEditing && marketId != null) {
      _initializeForm(marketId);
    }
    return MarketFormState(
      isEditing: isEditing,
      marketId: marketId,
    );
  }

  Future<void> _initializeForm(int marketId) async {
    if (_loadingDetail) return;
    _loadingDetail = true;
    try {
      final detail = await _detailUseCase.execute(id: marketId);
      final imageFiles = await Future.wait(
        detail.imageUrlList.map((url) async {
          final tempDir = await getTemporaryDirectory();
          final fileName = path.basename(url);
          final filePath = path.join(tempDir.path, fileName);

          final file = File(filePath);
          if (!await file.exists()) {
            final response = await HttpClient().getUrl(Uri.parse(url));
            final bytes = await (await response.close())
                .fold<List<int>>([], (a, b) => a..addAll(b));
            await file.writeAsBytes(bytes);
          }
          return XFile(file.path);
        }),
      );

      state = state.copyWith(
        title: detail.title,
        content: detail.content,
        price: detail.price,
        type: MarketType.values.firstWhere((e) => e.name == detail.type),
        images: imageFiles,
        initialImageUrls: detail.imageUrlList,
      );
    } catch (_) {
    } finally {
      _loadingDetail = false;
    }
  }

  void updateTitle(String value) => state = state.copyWith(title: value);
  void updateContent(String value) => state = state.copyWith(content: value);

  void updatePrice(int value) {
    String? error;
    if (value > MarketFormState.maxPrice) {
      error = '9,999,999원 이하 금액만 입력 가능해요!';
    }

    state = state.copyWith(
      price: value,
      priceErrorText: error,
    );
  }

  void updateType(MarketType value) => state = state.copyWith(type: value);
  void updateImages(List<XFile> value) => state = state.copyWith(images: value);

  void addImage(XFile image) {
    if (state.images.length >= 3) return;
    updateImages([...state.images, image]);
  }

  void removeImageAt(int index) {
    final updated = [...state.images]..removeAt(index);
    updateImages(updated);
  }

  Future<void> clearTemporaryImages() async {
    for (final image in state.images) {
      try {
        final file = File(image.path);
        if (await file.exists()) await file.delete();
      } catch (_) {}
    }
  }

  Future<void> compressAndAddImage(XFile pickedFile) async {
    if (state.images.length >= 3) return;
    if (_compressing) return;
    _compressing = true;

  try {
    final file = File(pickedFile.path);
    final dir = await getTemporaryDirectory();
    final currentCount = state.images.length + 1;
    final targetSizeMB = 3 / currentCount;
    const maxTry = 5;
    File? compressedFile;
    int quality = 90;
    int attempt = 0;

    while (attempt < maxTry) {
      final targetPath = path.join(
        dir.path,
        'compressed_${DateTime.now().millisecondsSinceEpoch}_$attempt.jpg',
      );

      final tmpFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        minWidth: 1024,
        minHeight: 1024,
      );

      if (tmpFile == null) break;

      final compressedSizeMB = (await tmpFile.length()) / (1024 * 1024);
      if (compressedSizeMB <= targetSizeMB) {
        compressedFile = File(tmpFile.path);
        break;
      }

      quality -= 10;
      attempt++;
    }

    if (compressedFile != null) {
      addImage(XFile(compressedFile.path));
    }
  } finally {
    _compressing = false;
  }
}

  Future<bool> submitMarket(BuildContext context) async {
    if (_submitting) return false;
    _submitting = true;

    if (state.isSubmitting || !state.isValid) {
      _submitting = false;
      return false;
    }

    state = state.copyWith(
      isSubmitting: true,
      isFiltering: true,
      errorMessage: null,
      profanityMessage: null,
    );

    try {
      final filteredTitle = state.title.replaceAll('|', '');
      final filteredContent = state.content.replaceAll('|', '');

      await _aiFilterUseCase.execute(
        entity: MarketAIFilterEntity(title: filteredTitle, content: filteredContent),
      );

      state = state.copyWith(isFiltering: false);

      final newImages = state.images.where((xfile) {
        final basename = path.basename(xfile.path);
        return !state.initialImageUrls.any((url) => url.contains(basename));
      }).toList();

      final deletedUrls = state.initialImageUrls.where((url) {
        final basename = path.basename(Uri.parse(url).path);
        return !state.images.any((x) => basename == path.basename(x.path));
      }).toList();

      final entity = MarketWriteEntity(
        title: state.title,
        content: state.content,
        price: state.price,
        type: state.type!,
        images: newImages,
        deleteImageUrls: deletedUrls,
      );

      if (state.marketId != null) {
        await _updateUseCase.execute(marketId: state.marketId!, entity: entity);
      } else {
        await _writeUseCase.execute(entity: entity);
      }

      return true;
    } on ProfanityDetectedException catch (e) {
      state = state.copyWith(isFiltering: false);
      _setProfanityMessage(e);
      return false;
    } catch (e) {
      state = state.copyWith(isFiltering: false, errorMessage: e.toString());
      rethrow;
    } finally {
      _submitting = false;
      state = state.copyWith(isSubmitting: false);
    }
  }

  void _setProfanityMessage(ProfanityDetectedException e) {
    final badSentences = <String>[];
    final Map<String, dynamic> data = e.responseData;

    for (final field in ['제목', '내용']) {
      final section = data[field];
      if (section != null && section['results'] is List) {
        for (final result in section['results']) {
          if (result['label'] == '비속어') {
            final sentence = result['sentence'];
            badSentences.add('[$field]에서 "$sentence" 에 비속어가 포함되어 있습니다.');
          }
        }
      }
    }

    if (badSentences.isNotEmpty) {
      final message = badSentences.join('\n');
      state = state.copyWith(
        profanityMessage: message,
        profanityMessageTriggerKey: state.profanityMessageTriggerKey + 1,
      );
    }
  }

  void clearProfanityMessage() =>
      state = state.copyWith(profanityMessage: null);
}
