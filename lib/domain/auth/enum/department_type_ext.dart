import 'department_type.dart';

class DepartmentTypeInfo {
  final String code;
  final String displayName;

  const DepartmentTypeInfo({
    required this.code,
    required this.displayName,
  });
}

extension DepartmentTypeExtension on DepartmentType {
  static const Map<DepartmentType, DepartmentTypeInfo> infoMap = {
    DepartmentType.Dept2001: DepartmentTypeInfo(
      code: "DEPT_2001",
      displayName: "컴퓨터소프트웨어공학과",
    ),
    DepartmentType.Dept2002: DepartmentTypeInfo(
      code: "DEPT_2002",
      displayName: "인공지능소프트웨어학과",
    ),
    DepartmentType.Dept2003: DepartmentTypeInfo(
      code: "DEPT_2003",
      displayName: "웹응용소프트웨어공학과",
    ),
    DepartmentType.Dept3001: DepartmentTypeInfo(
      code: "DEPT_3001",
      displayName: "기계공학과",
    ),
    DepartmentType.Dept3002: DepartmentTypeInfo(
      code: "DEPT_3002",
      displayName: "기계설계공학과",
    ),
    DepartmentType.Dept4001: DepartmentTypeInfo(
      code: "DEPT_4001",
      displayName: "자동화공학과",
    ),
    DepartmentType.Dept4002: DepartmentTypeInfo(
      code: "DEPT_4002",
      displayName: "로봇소프트웨어과",
    ),
    DepartmentType.Dept5001: DepartmentTypeInfo(
      code: "DEPT_5001",
      displayName: "전기공학과",
    ),
    DepartmentType.Dept5002: DepartmentTypeInfo(
      code: "DEPT_5002",
      displayName: "반도체전자공학과",
    ),
    DepartmentType.Dept5003: DepartmentTypeInfo(
      code: "DEPT_5003",
      displayName: "정보통신공학과",
    ),
    DepartmentType.Dept5004: DepartmentTypeInfo(
      code: "DEPT_5004",
      displayName: "소방안전관리과",
    ),
    DepartmentType.Dept6001: DepartmentTypeInfo(
      code: "DEPT_6001",
      displayName: "생명화학공학과",
    ),
    DepartmentType.Dept6002: DepartmentTypeInfo(
      code: "DEPT_6002",
      displayName: "바이오융합공학과",
    ),
    DepartmentType.Dept6003: DepartmentTypeInfo(
      code: "DEPT_6003",
      displayName: "건축과",
    ),
    DepartmentType.Dept6004: DepartmentTypeInfo(
      code: "DEPT_6004",
      displayName: "실내건축디자인과",
    ),
    DepartmentType.Dept6005: DepartmentTypeInfo(
      code: "DEPT_6005",
      displayName: "시각디자인과",
    ),
    DepartmentType.Dept6006: DepartmentTypeInfo(
      code: "DEPT_6006",
      displayName: "AR·VR콘텐츠디자인과",
    ),
    DepartmentType.Dept7001: DepartmentTypeInfo(
      code: "DEPT_7001",
      displayName: "경영학과",
    ),
    DepartmentType.Dept7002: DepartmentTypeInfo(
      code: "DEPT_7002",
      displayName: "세무회계학과",
    ),
    DepartmentType.Dept7003: DepartmentTypeInfo(
      code: "DEPT_7003",
      displayName: "유통마케팅학과",
    ),
    DepartmentType.Dept7004: DepartmentTypeInfo(
      code: "DEPT_7004",
      displayName: "호텔관광학과",
    ),
    DepartmentType.Dept7005: DepartmentTypeInfo(
      code: "DEPT_7005",
      displayName: "경영정보학과",
    ),
    DepartmentType.Dept7006: DepartmentTypeInfo(
      code: "DEPT_7006",
      displayName: "빅데이터경영과",
    ),
    DepartmentType.Dept8001: DepartmentTypeInfo(
      code: "DEPT_8001",
      displayName: "자유전공학과",
    ),
    DepartmentType.Dept9001: DepartmentTypeInfo(
      code: "DEPT_9001",
      displayName: "교양과",
    ),
    DepartmentType.Unknown: DepartmentTypeInfo(
      code: "UNKNOWN",
      displayName: "알 수 없음",
    ),
  };

  String get code => infoMap[this]!.code;
  String get displayName => infoMap[this]!.displayName;

  static DepartmentType fromCode(String code) {
    return infoMap.entries
        .firstWhere(
          (e) => e.value.code == code,
          orElse: () => MapEntry(
              DepartmentType.Unknown, infoMap[DepartmentType.Unknown]!),
        )
        .key;
  }

  static DepartmentType fromDisplayName(String name) {
    return infoMap.entries
        .firstWhere(
          (e) => e.value.displayName == name,
          orElse: () => MapEntry(
              DepartmentType.Unknown, infoMap[DepartmentType.Unknown]!),
        )
        .key;
  }
}
