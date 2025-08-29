import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:hive/hive.dart';

class LocalTimetableInfo {
  final int year;
  final Semester semester;

  LocalTimetableInfo({required this.year, required this.semester});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LocalTimetableInfo &&
              runtimeType == other.runtimeType &&
              year == other.year &&
              semester == other.semester;

  @override
  int get hashCode => year.hashCode ^ semester.hashCode;
}

class LocalTimetableInfoAdapter extends TypeAdapter<LocalTimetableInfo> {
  @override
  final int typeId = 3;

  @override
  LocalTimetableInfo read(BinaryReader reader) {
    final year = reader.readInt();
    final semesterIndex = reader.readInt();
    return LocalTimetableInfo(
      year: year,
      semester: Semester.values[semesterIndex],
    );
  }

  @override
  void write(BinaryWriter writer, LocalTimetableInfo obj) {
    writer.writeInt(obj.year);
    writer.writeInt(obj.semester.index);
  }
}