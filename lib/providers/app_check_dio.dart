import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/core/network/app_check_interceptor.dart';

final appCheckInterceptorProvider = Provider<AppCheckInterceptor>((ref) {
  final inst = AppCheckInterceptor();
  ref.onDispose(inst.dispose);
  return inst;
});
