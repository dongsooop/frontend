import 'package:dongsoop/domain/users/entities/user_entity.dart';
import 'package:dongsoop/domain/users/view_models/user_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<UserNotifier, bool>((ref) {
  return UserNotifier(ref);
});

final userProvider = StateProvider<UserEntity?>((ref) => null);
