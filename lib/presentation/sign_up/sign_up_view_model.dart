import 'dart:async';
import 'package:dongsoop/domain/auth/enum/department_type_ext.dart';
import 'package:dongsoop/domain/auth/model/sign_up_request.dart';
import 'package:dongsoop/domain/auth/use_case/sign_up_use_case.dart';
import 'package:dongsoop/presentation/sign_up/sign_up_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/domain/auth/enum/department_type.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/auth/use_case/check_duplicate_use_case.dart';

class SignUpViewModel extends StateNotifier<SignUpState> {
  final SignUpUseCase _signUpUseCase;
  final CheckDuplicateUseCase _checkDuplicateUseCase;

  SignUpViewModel(
    this._signUpUseCase,
    this._checkDuplicateUseCase,
  ) : super(
    SignUpState(
      isLoading: false,
      email: EmailValidationState(isLoading: false),
      password: PasswordValidationState(),
      nickname: NicknameValidationState(isLoading: false),
      dept: DeptValidationState(),
      isEmailValid: false,
      isPasswordValid: false,
      isNicknameValid: false,
      isDeptValid: false,
    )
  );

  String _prevEmailValue = '@dongyang.ac.kr';
  String _prevPassword = '';
  String _prevPasswordCheck = '';
  String _prevNicknameValue = '';

  // 이메일
  // 이메일 유효성
  bool isValidEmail(String email) {
    // 영문, 숫자, 일부 특수문자만 허용
    final emailReg = RegExp(r'^[a-zA-Z0-9._%+-]+@dongyang\.ac\.kr$');
    return emailReg.hasMatch(email);
  }

  // 이메일 검사
  void onEmailChanged(String email) {
    if (_prevEmailValue == email) {
      return;
    }
    _prevEmailValue = email;
    // 이메일 상태 초기화 및 값 반영
    final emailState = EmailValidationState(
      email: email,
      isFormatValid: false,
      isDuplicate: null,
      message: null,
      isError: null,
      isLoading: false,
    );
    state = state.copyWith(
      isEmailValid: false,
      email: emailState,
      errorMessage: null
    );

    // 이메일 형식 검사
    if (!isValidEmail(email)) {
      state = state.copyWith(
        email: state.email.copyWith(
          isFormatValid: false,
          message: '이메일을 올바르게 입력해 주세요',
          isError: true,
        ),
      );
      return;
    }
    state = state.copyWith(
      email: state.email.copyWith(
        email: email,
        isFormatValid: true,
        message: '중복 확인이 필요해요',
        isError: true,
      ),
      errorMessage: null,
    );
  }

  // 이메일 중복 확인
  Future<void> checkEmailDuplication(String email) async {
    // 이메일 형식(isFormatValid)이 일치하는지 확인 -> false라면 return;
    if (state.email.isFormatValid != true) return;

    state = state.copyWith(
      email: state.email.copyWith(
        isLoading: true,
        message: '',
      )
    );
    try {
      final isDuplicate = await _checkDuplicateUseCase.execute(email+'@dongyang.ac.kr', 'email');
      state = state.copyWith(
        isEmailValid: !isDuplicate,
        email: state.email.copyWith(
          email: email,
          isDuplicate: isDuplicate,
          message: isDuplicate ? '사용 중인 이메일이에요' : '',
          isError: isDuplicate,
          isLoading: false
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "회원가입 중 오류가 발생했습니다.",
        email: state.email.copyWith(
          isDuplicate: null,
          isLoading: false,
        ),
      );
    }
  }

  // 비밀번호
  // 비밀번호 유효성
  void onPasswordChanged(String password, [String? passwordCheck]) {
    // 중복 호출 방지
    if (_prevPassword == password && (_prevPasswordCheck == (passwordCheck ?? ''))) return;
    _prevPassword = password;
    _prevPasswordCheck = passwordCheck ?? '';

    state = state.copyWith(
      isPasswordValid: false
    );

    // 1. 영문만 사용했는가?
    final isEnglishValid = RegExp(r'^[a-zA-Z0-9!@#\$%^&*(),.?":{}|<>~`$begin:math:display$$end:math:display$\\/\-_=+]+$').hasMatch(password)
        && !RegExp(r'[ㄱ-ㅎ가-힣ぁ-ゔァ-ヴー一-龥]').hasMatch(password);
    if (!isEnglishValid) {
      state = state.copyWith(
        password: state.password.copyWith(
          password: password,
          isEnglishValid: false,
          message: "영문, 숫자, 특수문자만 사용 가능해요",
          isError: true,
        ),
      );
      return;
    }

    // 2. 8글자 이상인가?
    final isNumberFormatValid = password.length >= 8;
    if (!isNumberFormatValid) {
      state = state.copyWith(
        password: state.password.copyWith(
          password: password,
          isEnglishValid: true,
          isNumberFormatValid: false,
          message: "8자 이상 입력해 주세요",
          isError: true,
        ),
      );
      return;
    }

    // 3. 영문 1개 이상
    final isEnglishCharValid = RegExp(r'[a-zA-Z]').hasMatch(password);
    if (!isEnglishCharValid) {
      state = state.copyWith(
        password: state.password.copyWith(
          password: password,
          isEnglishValid: true,
          isNumberFormatValid: true,
          message: "영문을 1개 이상 포함해야 해요",
          isError: true,
        ),
      );
      return;
    }

    // 4. 특수문자 1개 이상
    final isSpecialCharacterValid = RegExp(r'[!@#\$%^&*(),.?":{}|<>~`\[\]\\/\-_=+]').hasMatch(password);
    if (!isSpecialCharacterValid) {
      state = state.copyWith(
        password: state.password.copyWith(
          password: password,
          isEnglishValid: true,
          isNumberFormatValid: true,
          isSpecialCharacterValid: false,
          message: "특수문자를 1개 이상 포함해야 해요",
          isError: true,
        ),
      );
      return;
    }

    // 5. 숫자 1개 이상
    final isNumberValid = RegExp(r'[0-9]').hasMatch(password);
    if (!isNumberValid) {
      state = state.copyWith(
        password: state.password.copyWith(
          password: password,
          isEnglishValid: true,
          isNumberFormatValid: true,
          isSpecialCharacterValid: true,
          message: "숫자를 1개 이상 포함해야 해요",
          isError: true,
        ),
      );
      return;
    }

    // 6. 비밀번호와 확인 일치
    final isChecked = passwordCheck != null && password.isNotEmpty
      ? password == passwordCheck
      : null;
    if (isChecked == false) {
      state = state.copyWith(
        password: state.password.copyWith(
          password: password,
          isEnglishValid: true,
          isNumberFormatValid: true,
          isSpecialCharacterValid: true,
          isChecked: false,
          message: "비밀번호가 일치하지 않아요.",
          isError: true,
        ),
      );
      return;
    }

    // 모든 유효성 통과
    state = state.copyWith(
      isPasswordValid: true,
      password: state.password.copyWith(
        password: password,
        isEnglishValid: true,
        isNumberFormatValid: true,
        isSpecialCharacterValid: true,
        isChecked: isChecked,
        message: '',
        isError: false,
      ),
    );
  }

  // 비밀번호 확인만 따로 입력시 호출
  void onPasswordCheckChanged(String passwordCheck) {
    onPasswordChanged(state.password.password ?? '', passwordCheck);
  }

  // 닉네임
  // 닉네임 유효성
  void onNicknameChanged(String nickname) {
    if (_prevNicknameValue == nickname) {
      return;
    }
    _prevNicknameValue = nickname;

    state = state.copyWith(isNicknameValid: false);

    if (nickname.length < 2 || nickname.length > 8) {
      state = state.copyWith(
        nickname: state.nickname.copyWith(
          nickname: nickname,
          isNumberFormatValid: false,
          message: '2~8글자로 입력해 주세요',
          isError: true,
        ),
      );
      return;
    }

    final specialCharReg = RegExp(r'[^a-zA-Z0-9가-힣]');
    if (specialCharReg.hasMatch(nickname)) {
      state = state.copyWith(
        nickname: state.nickname.copyWith(
          nickname: nickname,
          isNumberFormatValid: true,
          isSpecialCharacterValid: false,
          message: '닉네임에 특수문자를 포함할 수 없어요',
          isError: true,
        ),
      );
      return;
    }

    state = state.copyWith(
      nickname: state.nickname.copyWith(
        nickname: nickname,
        isNumberFormatValid: true,
        isSpecialCharacterValid: true,
        isDuplicate: false,
        message: '중복 확인이 필요해요',
        isError: true,
      ),
      errorMessage: null,
    );
  }

  // 닉네임 중복 확인
  Future<void> checkNicknameDuplication(String nickname) async {
    // 닉네임 형식 일치 확인
    if (state.nickname.isDuplicate == null) return;

    state = state.copyWith(
      nickname: state.nickname.copyWith(
        isLoading: true,
        message: '',
      ),
    );

    try {
      final isDuplicate = await _checkDuplicateUseCase.execute(nickname, 'nickname');
      state = state.copyWith(
        isNicknameValid: !isDuplicate,
        nickname: state.nickname.copyWith(
          nickname: nickname,
          isDuplicate: isDuplicate,
          message: isDuplicate ? '사용 중인 닉네임이에요' : '',
          isError: isDuplicate,
          isLoading: false,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: "회원가입 중 오류가 발생했습니다.",
        nickname: state.nickname.copyWith(
          isDuplicate: null,
          isLoading: false,
        ),
      );
    }
  }

  // 학과
  void selectDept(DepartmentType? dept) {
    if (dept == null) {
      return;
    }
    state = state.copyWith(isDeptValid: false);
    // 뭔가 선택됨
    state = state.copyWith(
      isDeptValid: true,
      dept: state.dept.copyWith(
        dept: dept.code.toString(),
        isSelected: true,
      ),
    );
  }

  // 회원가입
  Future<bool> signUp() async {
    state = state.copyWith(isLoading: true);

    try {
      final request = SignUpRequest(
        email: state.email.email! + '@dongyang.ac.kr',
        password: state.password.password ?? '',
        nickname: state.nickname.nickname ?? '',
        departmentType: state.dept.dept ?? '',
      );
      await _signUpUseCase.execute(request);
      state = state.copyWith(isLoading: false);
      return true;
    } on SignUpException catch (e) {
      state = state.copyWith(
        isLoading: false,
        email: state.email.copyWith(
          isError: true,
          message: e.message,
        ),
        password: state.password.copyWith(
          isError: true,
          message: e.message,
        ),
        nickname: state.nickname.copyWith(
          isError: true,
          message: e.message,
        ),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '회원가입 중 오류가 발생했습니다.',
      );
      return false;
    }
  }
}