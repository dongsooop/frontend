import 'package:dongsoop/presentation/board/recruit/write/state/date_time_state.dart';

class RecruitFormState {
  final int? selectedTypeIndex;
  final String title;
  final String content;
  final List<String> tags;
  final List<String> majors;
  final DateTimeState dateTime;
  final bool isLoading;

  const RecruitFormState({
    this.selectedTypeIndex,
    this.title = '',
    this.content = '',
    this.tags = const [],
    this.majors = const [],
    required this.dateTime,
    this.isLoading = false,
  });

  RecruitFormState copyWith({
    int? selectedTypeIndex,
    String? title,
    String? content,
    List<String>? tags,
    List<String>? majors,
    DateTimeState? dateTime,
    bool? isLoading,
  }) {
    return RecruitFormState(
      selectedTypeIndex: selectedTypeIndex ?? this.selectedTypeIndex,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      majors: majors ?? this.majors,
      dateTime: dateTime ?? this.dateTime,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
