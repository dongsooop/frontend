import 'package:dongsoop/presentation/board/recruit/write/state/date_time_state.dart';
import 'package:dongsoop/presentation/board/recruit/write/view_models/data_time_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dateTimeSelectorProvider =
    StateNotifierProvider<DateTimeSelectorViewModel, DateTimeSelectorState>(
  (ref) => DateTimeSelectorViewModel(),
);
