import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class SignInScreen extends StatefulWidget {
  final VoidCallback onTapSignUp;

  const SignInScreen({
    super.key,
    required this.onTapSignUp,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController userPwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(
              Icons.chevron_left_outlined,
              size: 24,
              color: ColorStyles.black,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16,
            children: [
              SizedBox(height: 24,),
              SvgPicture.asset(
                'assets/icons/logo.svg',
                width: 128,
                height: 128,
                colorFilter: const ColorFilter.mode(
                  ColorStyles.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: 8,),
              Container(
                width: double.infinity,
                height: 44,
                margin: EdgeInsets.only(top: 8),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: ColorStyles.gray2),
                    borderRadius: BorderRadius.circular(8)
                  )
                ),
                child: TextFormField(
                  cursorColor: ColorStyles.gray4,
                  keyboardType: TextInputType.emailAddress,
                  controller: userIdController,
                  style: TextStyles.normalTextRegular.copyWith(
                    color: ColorStyles.black
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
                    border: InputBorder.none,
                    hintText: '이메일을 입력해 주세요',
                    hintStyle: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
                  ),
                  onChanged: (value) {
                    setState(() { });
                  },
                ),
              ),
              Container(
                width: double.infinity,
                height: 44,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: ColorStyles.gray2),
                    borderRadius: BorderRadius.circular(8)
                  )
                ),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  cursorColor: ColorStyles.gray4,
                  obscureText: true,
                  controller: userPwController,
                  style: TextStyles.normalTextRegular.copyWith(
                    color: ColorStyles.black
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
                    border: InputBorder.none,
                    hintText: '비밀번호를 입력해 주세요',
                    hintStyle: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
                  ),
                  onChanged: (value) {
                    setState(() { });
                  },
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorStyles.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '로그인',
                    style: TextStyles.normalTextBold.copyWith(
                      color: ColorStyles.white
                    ),
                  ),
                ),
              ),
              // 회원가입 버튼
              GestureDetector(
                onTap: widget.onTapSignUp,
                child: Container(
                  width: double.infinity,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorStyles.primaryColor, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '회원가입',
                    style: TextStyles.normalTextBold.copyWith(
                      color: ColorStyles.primaryColor
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
