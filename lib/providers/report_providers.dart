import 'package:dongsoop/presentation/report/report_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/report/report_view_model.dart';

// View Model
final reportViewModelProvider =
StateNotifierProvider<ReportViewModel, ReportState>((ref) {
  return ReportViewModel();
});