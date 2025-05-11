import 'package:dongsoop/presentation/board/recruit/write/viewmodels/data_time_viemodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dateTimeSelectorProvider =
    StateNotifierProvider<DateTimeSelectorViewModel, DateTimeSelectorState>(
  (ref) => DateTimeSelectorViewModel(),
);
