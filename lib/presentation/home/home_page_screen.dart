import 'package:dongsoop/core/provider/user_provider.dart';
import 'package:dongsoop/presentation/home/widgets/home_header.dart';
import 'package:dongsoop/presentation/home/widgets/home_new_notice.dart';
import 'package:dongsoop/presentation/home/widgets/home_popular_recruits.dart';
import 'package:dongsoop/presentation/home/widgets/home_today.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePageScreen extends ConsumerStatefulWidget {
  const HomePageScreen({super.key});

  @override
  ConsumerState<HomePageScreen> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePageScreen> {
  @override
  // void initState() {
  //   super.initState();
  //   _initLogin();
  // }

  // Future<void> _initLogin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('accessToken');
  //
  //   final storedToken = prefs.getString('accessToken');
  //   final storedUserData = prefs.getString('USER_DATA');
  //
  //   debugPrint('저장된 accessToken: $storedToken');
  //   debugPrint('저장된 USER_DATA: $storedUserData');
  //
  //   // 이미 토큰이 있으면 무조건 로컬에서 복원만
  //   if (token != null && token.isNotEmpty) {
  //     debugPrint('로컬 토큰 발견 → 로컬 유저 복원');
  //     await ref.read(userNotifierProvider.notifier).restoreUserFromStorage();
  //     return;
  //   }
  //
  //   // 최초 로그인
  //   try {
  //     final repo = ref.read(userRepositoryProvider);
  //     final userModel = await repo.login();
  //     final userEntity = userModel.toEntity();
  //
  //     await ref
  //         .read(userNotifierProvider.notifier)
  //         .login(userEntity, userModel.accessToken, userModel);
  //   } catch (e, st) {
  //     debugPrint('로그인 실패: $e\n$st');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final isLoggedIn = ref.watch(userNotifierProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
            color: Colors.white,
          ),
          Expanded(
            child: Scaffold(
              backgroundColor: ColorStyles.white,
              body: SafeArea(
                top: false,
                bottom: false,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // // 임시 로그인
                      // if (isLoggedIn && user != null)
                      //   Padding(
                      //     padding: const EdgeInsets.all(16),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text('로그인 유저: ${user.nickname}'),
                      //         const SizedBox(height: 8),
                      //         ElevatedButton(
                      //           onPressed: () {
                      //             ref
                      //                 .read(userNotifierProvider.notifier)
                      //                 .logout();
                      //           },
                      //           child: const Text('로그아웃'),
                      //         ),
                      //       ],
                      //     ),
                      //   )
                      // else
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('게스트'),
                      ),
                      const MainHeader(),
                      const HomeToday(),
                      const HomeNewNotice(),
                      const HomePopularRecruits(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).padding.bottom,
            color: ColorStyles.white,
          ),
        ],
      ),
    );
  }
}
