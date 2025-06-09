class RecruitFormState {
  final int? selectedTypeIndex;
  final String title;
  final String content;
  final List<String> tags;
  final List<String> majors;
  final bool isLoading;

  const RecruitFormState({
    this.selectedTypeIndex,
    this.title = '',
    this.content = '',
    this.tags = const [],
    this.majors = const [],
    this.isLoading = false,
  });

  RecruitFormState copyWith({
    int? selectedTypeIndex,
    String? title,
    String? content,
    List<String>? tags,
    List<String>? majors,
    bool? isLoading,
  }) {
    return RecruitFormState(
      selectedTypeIndex: selectedTypeIndex ?? this.selectedTypeIndex,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      majors: majors ?? this.majors,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
