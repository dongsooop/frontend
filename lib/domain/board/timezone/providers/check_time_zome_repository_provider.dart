import 'package:dongsoop/data/board/timezone/repository/check_time_zone_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final checkTimeZoneRepositoryProvider = Provider((ref) => CheckTimeZoneRepositoryImpl());