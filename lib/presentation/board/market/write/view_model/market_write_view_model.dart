import 'dart:io';

import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/board/market/entities/market_ai_filter_entity.dart';
import 'package:dongsoop/domain/board/market/entities/market_write_entity.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/domain/board/market/use_cases/market_ai_filter_use_case.dart';
import 'package:dongsoop/domain/board/market/use_cases/market_write_use_case.dart';
import 'package:dongsoop/main.dart';
import 'package:dongsoop/presentation/board/market/state/market_write_state.dart';
import 'package:dongsoop/presentation/board/providers/market/market_ai_filter_use_case_provider.dart';
import 'package:dongsoop/presentation/board/providers/market/market_write_use_case_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'market_write_view_model.g.dart';

@riverpod
class MarketWriteViewModel extends _$MarketWriteViewModel {
  MarketWriteUseCase get _writeUseCase => ref.watch(marketWriteUseCaseProvider);
  MarketAIFilterUseCase get _aiFilterUseCase =>
      ref.watch(marketAiFilterUseCaseProvider);

  @override
  MarketFormState build() => const MarketFormState();

  void updateTitle(String value) {
    state = state.copyWith(title: value);
  }

  void updateContent(String value) {
    state = state.copyWith(content: value);
  }

  void updatePrice(int value) {
    state = state.copyWith(price: value);
  }

  void updateType(MarketType value) {
    logger.d('Type updated: $value');
    state = state.copyWith(type: value);
  }

  void updateImages(List<XFile> value) {
    logger.d('Images updated: ${value.map((e) => e.path).toList()}');
    state = state.copyWith(images: value);
  }

  void addImage(XFile image) {
    if (state.images.length >= 3) return;
    final updated = [...state.images, image];
    updateImages(updated);
  }

  void removeImageAt(int index) {
    final updated = [...state.images]..removeAt(index);
    updateImages(updated);
  }

  Future<void> clearTemporaryImages() async {
    for (final image in state.images) {
      try {
        final file = File(image.path);
        if (await file.exists()) {
          await file.delete();
          logger.i('[MARKET] 임시 이미지 삭제 완료: ${image.path}');
        }
      } catch (e) {
        logger.w('[MARKET] 이미지 삭제 중 오류 발생: $e');
      }
    }
  }

  Future<void> compressAndAddImage(XFile pickedFile) async {
    if (state.images.length >= 3) return;
    final file = File(pickedFile.path);
    final currentCount = state.images.length + 1;
    final targetSizeMB = 3 / currentCount;
    const maxTry = 5;

    final dir = await getTemporaryDirectory();
    final targetPath = path.join(
      dir.path,
      'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    File? compressedFile;
    int quality = 90;
    int attempt = 0;

    while (attempt < maxTry) {
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
      final compressedXFile = XFile(compressedFile.path);
      final compressedSizeMB = (await compressedFile.length()) / (1024 * 1024);
      addImage(compressedXFile);
      logger.i(
          '[MARKET] 이미지 압축 성공 및 추가 (크기: ${compressedSizeMB.toStringAsFixed(2)} MB)');
    } else {
      logger.w('[MARKET] 이미지 압축 실패');
    }
  }

  Future<void> submitMarket(BuildContext context) async {
    logger.i('[MARKET] submitMarket 시작');

    if (state.isSubmitting || !state.isValid) {
      logger.w(
          '중복 제출 혹은 유효하지 않은 상태 - isSubmitting: ${state.isSubmitting}, isValid: ${state.isValid}');
      return;
    }

    state = state.copyWith(
        isSubmitting: true, errorMessage: null, profanityMessage: null);

    try {
      logger.i('AI 비속어 필터 검사 요청');
      await _aiFilterUseCase.execute(
        entity: MarketAIFilterEntity(
          title: state.title,
          content: state.content,
        ),
      );
      logger.i('AI 필터 통과');

      logger.i('게시글 작성 요청 전송');
      await _writeUseCase.execute(
        entity: MarketWriteEntity(
          title: state.title,
          content: state.content,
          price: state.price,
          type: state.type!,
          images: state.images,
        ),
      );
      logger.i('게시글 작성 성공');
    } on ProfanityDetectedException catch (e) {
      logger.w('비속어 감지');
      _setProfanityMessage(e);
    } catch (e, st) {
      logger.e('게시글 작성 실패', error: e, stackTrace: st);
      state = state.copyWith(errorMessage: e.toString());
    } finally {
      logger.i('submitMarket 종료');
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
      state = state.copyWith(profanityMessage: message);
    }
  }

  void clearProfanityMessage() {
    state = state.copyWith(profanityMessage: null);
  }
}
