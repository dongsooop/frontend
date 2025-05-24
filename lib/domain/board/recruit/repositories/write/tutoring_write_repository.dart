import 'package:dongsoop/domain/board/recruit/entities/write/tutoring_write_entity.dart';

abstract class TutoringRepository {
  Future<void> tutoringWrite(TutoringWriteEntity tutoring);
}
