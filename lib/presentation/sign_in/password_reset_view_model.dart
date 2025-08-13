import 'dart:async';
import 'package:dongsoop/domain/auth/use_case/password_check_email_code_use_case.dart';
import 'package:dongsoop/domain/auth/use_case/password_send_email_code_use_case.dart';
import 'package:dongsoop/domain/auth/use_case/update_password_use_case.dart';
import 'package:dongsoop/presentation/sign_in/password_reset_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/auth/use_case/check_duplicate_use_case.dart';

class PasswordResetViewModel extends StateNotifier<PasswordResetState> {
  Timer? _timer;
  final CheckDuplicateUseCase _checkDuplicateUseCase;
  final PasswordSendEmailCodeUseCase _passwordSendEmailCodeUseCase;
  final PasswordCheckEmailCodeUseCase _passwordCheckEmailCodeUseCase;
  final UpdatePasswordUseCase _updatePasswordUseCase;

  PasswordResetViewModel(
    this._checkDuplicateUseCase,
    this._passwordSendEmailCodeUseCase,
    this._passwordCheckEmailCodeUseCase,
    this._updatePasswordUseCase
  ) : super(
    PasswordResetState(
      isLoading: false,
      isEmailValid: false,
      email: PasswordResetEmailValidationState(isLoading: false),
      emailCode: PasswordResetEmailVerificationCodeState(isCodeLoading: false, isCheckLoading: false),
      password: PasswordResetValidationState(),
      isPasswordValid: false,
      isEmailStep: true,
    ),
  );

  String _prevEmailValue = '@dongyang.ac.kr';
  String _prevPassword = '';
  String _prevPasswordCheck = '';

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
    final emailState = PasswordResetEmailValidationState(
      email: email,
      isFormatValid: false,
      isDuplicate: null,
      message: null,
      isError: null,
      isLoading: false,
    );
    final emailCodeState = PasswordResetEmailVerificationCodeState(
      isTimerRunning: false,
      remainingSeconds: null,
      isChecked: null,
      message: null,
      isError: null,
      isCodeLoading: false,
      isCheckLoading: false,
    );
    state = state.copyWith(
        isEmailValid: false,
        email: emailState,
        emailCode: emailCodeState,
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
        message: '이메일 확인이 필요해요',
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
      ),
    );
    try {
      final isDuplicate = await _checkDuplicateUseCase.execute(email+'@dongyang.ac.kr', 'email');
      state = state.copyWith(
        isEmailValid: false,
        email: state.email.copyWith(
          email: email,
          isDuplicate: !isDuplicate,
          message: !isDuplicate ? '해당 이메일로 가입된 계정이 없어요' : '이메일 인증이 필요해요',
          isError: !isDuplicate,
          isLoading: false,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "이메일 확인 중 오류가 발생했습니다.",
        email: state.email.copyWith(
          isDuplicate: null,
          isLoading: false,
        ),
      );
    }
  }

  // 이메일 인증 코드 요청
  Future<void> sendEmailVerificationCode(String userEmail) async {
    if (state.email.isDuplicate != false) return;

    state = state.copyWith(
      emailCode: state.emailCode.copyWith(
        isCodeLoading: true,
        failCount: 0,
      ),
    );
    try {
      await _passwordSendEmailCodeUseCase.execute(userEmail + '@dongyang.ac.kr');
      startTimer();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "이메일 인증 중 오류가 발생했습니다.",
        emailCode: state.emailCode.copyWith(
          isCodeLoading: false,
        ),
      );
    }
  }

  void startTimer() {
    _timer?.cancel();
    state = state.copyWith(
      emailCode: state.emailCode.copyWith(
        isCodeLoading: false,
        isTimerRunning: true,
        remainingSeconds: 300,
      ),
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final next = state.emailCode.remainingSeconds! - 1;
      if (next <= 0) {
        timer.cancel();
        state = state.copyWith(
          emailCode: state.emailCode.copyWith(
            isTimerRunning: false,
            remainingSeconds: 0,
            failCount: 0,
          ),
        );
      } else {
        state = state.copyWith(
          emailCode: state.emailCode.copyWith(
            remainingSeconds: next,
            isTimerRunning: true,
          ),
        );
      }
    });
  }

  // 이메일 인증 코드 확인
  Future<void> checkEmailVerificationCode(String userEmail, String code) async {
    if (state.emailCode.isTimerRunning != true) return;

    state = state.copyWith(
      emailCode: state.emailCode.copyWith(
        isCheckLoading: true,
        message: '',
      ),
    );
    try {
      final isChecked = await _passwordCheckEmailCodeUseCase.execute(userEmail + '@dongyang.ac.kr', code);
      int nextFailCount = isChecked ? 0 : (state.emailCode.failCount + 1);
      bool shouldStopTimer = !isChecked && nextFailCount >= 3;

      String? errorMsg;
      if (shouldStopTimer) {
        errorMsg = "인증 코드가 3회 틀렸어요. 다시 인증해 주세요.";
      } else if (!isChecked) {
        errorMsg = "인증 코드가 일치하지 않아요";
      }

      if (isChecked || shouldStopTimer) _timer?.cancel();

      state = state.copyWith(
        isEmailValid: isChecked,
        email: state.email.copyWith(
          message: errorMsg ?? '',
        ),
        emailCode: state.emailCode.copyWith(
          isError: !isChecked,
          isChecked: isChecked,
          isCheckLoading: false,
          isTimerRunning: (isChecked || shouldStopTimer) ? false : state.emailCode.isTimerRunning,
          remainingSeconds: (isChecked || shouldStopTimer) ? 0 : state.emailCode.remainingSeconds,
          failCount: nextFailCount,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "이메일 인증 중 오류가 발생했습니다.",
        emailCode: state.emailCode.copyWith(
          isCheckLoading: false,
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
          message: "비밀번호가 일치하지 않아요",
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

  void onPasswordCheckChanged(String passwordCheck) {
    onPasswordChanged(state.password.password ?? '', passwordCheck);
  }

  // 비밀번호 변경
  Future<bool> passwordReset() async {
    state = state.copyWith(isLoading: true);

    try {
      final result = await _updatePasswordUseCase.execute(
        state.email.email! + '@dongyang.ac.kr',
        state.password.password ?? '',
      );
      state = state.copyWith(isLoading: false);
      return result;
    } on PWResetException catch (e) {
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
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '비밀번호 변경 중 오류가 발생했습니다.',
      );
      return false;
    }
  }

  void next() {
    state = state.copyWith(isEmailStep: false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}