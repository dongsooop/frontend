import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();

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
          centerTitle: true,
          title: Text(
            '동숲 회원가입',
            style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              SizedBox(height: 24,),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '이메일',
                      style: TextStyles.normalTextBold.copyWith(
                        color: ColorStyles.black,
                      ),
                    ),
                    TextSpan(
                      text: ' *',
                      style: TextStyles.normalTextBold.copyWith(
                        color: ColorStyles.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
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
                  controller: emailController,
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
              SizedBox(height: 8,),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '비밀번호',
                      style: TextStyles.normalTextBold.copyWith(
                        color: ColorStyles.black,
                      ),
                    ),
                    TextSpan(
                      text: ' *',
                      style: TextStyles.normalTextBold.copyWith(
                        color: ColorStyles.primaryColor,
                      ),
                    ),
                  ],
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
                  controller: passwordController,
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
                  controller: passwordController,
                  style: TextStyles.normalTextRegular.copyWith(
                    color: ColorStyles.black
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
                    border: InputBorder.none,
                    hintText: '비밀번호 확인',
                    hintStyle: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
                  ),
                  onChanged: (value) {
                    setState(() { });
                  },
                ),
              ),
              SizedBox(height: 8,),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '닉네임',
                      style: TextStyles.normalTextBold.copyWith(
                        color: ColorStyles.black,
                      ),
                    ),
                    TextSpan(
                      text: ' *',
                      style: TextStyles.normalTextBold.copyWith(
                        color: ColorStyles.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
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
                  controller: nicknameController,
                  style: TextStyles.normalTextRegular.copyWith(
                      color: ColorStyles.black
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
                    border: InputBorder.none,
                    hintText: '닉네임을 입력해 주세요',
                    hintStyle: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
                  ),
                  onChanged: (value) {
                    setState(() { });
                  },
                ),
              ),
              SizedBox(height: 8,),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '학과',
                      style: TextStyles.normalTextBold.copyWith(
                        color: ColorStyles.black,
                      ),
                    ),
                    TextSpan(
                      text: ' *',
                      style: TextStyles.normalTextBold.copyWith(
                        color: ColorStyles.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
