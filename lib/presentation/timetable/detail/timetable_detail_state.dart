import 'package:flutter_image_compress/flutter_image_compress.dart';

class TimetableDetailState {
  final bool isLoading;
  final String? errorMessage;
  final XFile? analysisImage;
  final bool isAnalyzing;
  final String? analysisLoadingMessage;
  final String? analysisErrorMessage;

  TimetableDetailState({
    required this.isLoading,
    this.errorMessage,
    this.analysisImage,
    this.isAnalyzing = false,
    this.analysisLoadingMessage,
    this.analysisErrorMessage,
  });

  bool get canSubmitAnalysis => analysisImage != null && !isAnalyzing;

  TimetableDetailState copyWith({
    bool? isLoading,
    String? errorMessage,
    XFile? analysisImage,
    bool clearAnalysisImage = false,
    bool? isAnalyzing,
    String? analysisLoadingMessage,
    String? analysisErrorMessage,
  }) {
    return TimetableDetailState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      analysisImage: clearAnalysisImage
          ? null
          : (analysisImage ?? this.analysisImage),
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      analysisLoadingMessage: analysisLoadingMessage,
      analysisErrorMessage: analysisErrorMessage,
    );
  }
}