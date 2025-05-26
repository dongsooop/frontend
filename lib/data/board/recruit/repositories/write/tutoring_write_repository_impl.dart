import 'package:dio/dio.dart';
import 'package:dongsoop/core/providers/user_provider.dart';
import 'package:dongsoop/data/board/recruit/model/write/recruit_write_model.dart';
import 'package:dongsoop/domain/board/recruit/entities/write/recruit_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/repositories/write/recruit_write_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TutoringWriteRepositoryImpl implements RecruitWriteRepository {
  final Dio dio;
  final Ref ref;
  TutoringWriteRepositoryImpl(this.dio, this.ref);

  @override
  Future<void> recruitWrite(RecruitWriteEntity entity) async {
    final endpoint = dotenv.get('TUTORING_ENDPOINT');
    final model = RecruitWriteModel.fromEntity(entity);

    final user = ref.read(userProvider);
    final token = user?.accessToken;

    if (token == null || token.isEmpty) {
      throw Exception('유효하지 않은 토큰입니다.');
    }

    try {
      await dio.post(
        endpoint,
        data: model.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
    } on DioException catch (e) {
      throw Exception('튜터링 게시글 작성 실패: ${e.message}');
    } catch (e) {
      throw Exception('튜터링 게시글 작성 실패: $e');
    }
  }
}
