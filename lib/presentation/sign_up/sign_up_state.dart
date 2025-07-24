class SignUpState {
  final bool isLoading;
  final String? errorMessage;
  final EmailValidationState email;
  final EmailVerificationCodeState emailCode;
  final PasswordValidationState password;
  final NicknameValidationState nickname;
  final DeptValidationState dept;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isNicknameValid;
  final bool isDeptValid;

  SignUpState({
    required this.isLoading,
    this.errorMessage,
    required this.email,
    required this.emailCode,
    required this.password,
    required this.nickname,
    required this.dept,
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.isNicknameValid,
    required this.isDeptValid,
  });

  SignUpState copyWith({
    bool? isLoading,
    String? errorMessage,
    EmailValidationState? email,
    EmailVerificationCodeState? emailCode,
    PasswordValidationState? password,
    NicknameValidationState? nickname,
    DeptValidationState? dept,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isNicknameValid,
    bool? isDeptValid,
  }) {
    return SignUpState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      email: email ?? this.email,
      emailCode: emailCode ?? this.emailCode,
      password: password ?? this.password,
      nickname: nickname ?? this.nickname,
      dept: dept ?? this.dept,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isNicknameValid: isNicknameValid ?? this.isNicknameValid,
      isDeptValid: isDeptValid ?? this.isDeptValid,
    );
  }
}

class EmailValidationState {
  final String? email;
  final bool? isFormatValid;
  final bool? isDuplicate;
  final String? message;
  final bool? isError;
  final bool isLoading;

  EmailValidationState({
    this.email,
    this.isFormatValid,
    this.isDuplicate,
    this.message,
    this.isError,
    required this.isLoading,
  });

  EmailValidationState copyWith({
    String? email,
    bool? isFormatValid,
    bool? isDuplicate,
    String? message,
    bool? isError,
    bool? isLoading,
  }) {
    return EmailValidationState(
      email: email ?? this.email,
      isFormatValid: isFormatValid ?? this.isFormatValid,
      isDuplicate: isDuplicate ?? this.isDuplicate,
      message: message ?? this.message,
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class EmailVerificationCodeState {
  final String? code;
  final bool? isCodeSent;
  final bool? isTimerRunning;
  final int? remainingSeconds;
  final bool? isChecked;
  final String? message;
  final bool? isError;
  final bool isCodeLoading;
  final bool isCheckLoading;

  EmailVerificationCodeState({
    this.code,
    this.isCodeSent,
    this.isTimerRunning,
    this.remainingSeconds,
    this.isChecked,
    this.message,
    this.isError,
    required this.isCodeLoading,
    required this.isCheckLoading,
  });

  EmailVerificationCodeState copyWith({
    String? code,
    bool? isCodeSent,
    bool? isTimerRunning,
    int? remainingSeconds,
    bool? isChecked,
    String? message,
    bool? isError,
    bool? isCodeLoading,
    bool? isCheckLoading,
  }) {
    return EmailVerificationCodeState(
      code: code,
      isCodeSent: isCodeSent,
      isTimerRunning: isTimerRunning,
      remainingSeconds: remainingSeconds,
      isChecked: isChecked,
      message: message ?? this.message,
      isError: isError ?? this.isError,
      isCodeLoading: isCodeLoading ?? this.isCodeLoading,
      isCheckLoading: isCheckLoading ?? this.isCheckLoading,
    );
  }
}

class PasswordValidationState {
  final String? password;
  final bool? isEnglishValid;
  final bool? isNumberFormatValid; // 숫자 포함?
  final bool? isSpecialCharacterValid; // 특수문자
  final bool? isChecked; // null: 검사 안함, true: 사용 가능, false: 불일치
  final String? message;
  final bool? isError;

  PasswordValidationState({
    this.password,
    this.isEnglishValid,
    this.isNumberFormatValid,
    this.isSpecialCharacterValid,
    this.isChecked,
    this.message,
    this.isError,
  });

  PasswordValidationState copyWith({
    String? password,
    bool? isEnglishValid,
    bool? isNumberFormatValid,
    bool? isSpecialCharacterValid,
    bool? isChecked,
    String? message,
    bool? isError,
  }) {
    return PasswordValidationState(
      password: password,
      isEnglishValid: isEnglishValid,
      isNumberFormatValid: isNumberFormatValid,
      isSpecialCharacterValid: isSpecialCharacterValid,
      isChecked: isChecked,
      message: message,
      isError: isError
    );
  }
}

class NicknameValidationState {
  final String? nickname;
  final bool? isNumberFormatValid; // 2자~8자
  final bool? isSpecialCharacterValid; // 특수문자 없어야됨
  final bool? isDuplicate; // null: 검사 안함, true: 중복, false: 사용가능
  final String? message;
  final bool? isError;
  final bool isLoading;

  NicknameValidationState({
    this.nickname,
    this.isNumberFormatValid,
    this.isSpecialCharacterValid,
    this.isDuplicate,
    this.message,
    this.isError,
    required this.isLoading,
  });

  NicknameValidationState copyWith({
    String? nickname,
    bool? isNumberFormatValid,
    bool? isSpecialCharacterValid,
    bool? isDuplicate,
    String? message,
    bool? isError,
    bool? isLoading,
  }) {
    return NicknameValidationState(
      nickname: nickname,
      isNumberFormatValid: isNumberFormatValid,
      isSpecialCharacterValid: isSpecialCharacterValid,
      isDuplicate: isDuplicate,
      message: message,
      isError: isError,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DeptValidationState {
  final String? dept;
  final bool? isSelected;

  DeptValidationState({
    this.dept,
    this.isSelected,
  });

  DeptValidationState copyWith({
    String? dept,
    bool? isSelected,
    String? message,
  }) {
    return DeptValidationState(
      dept: dept,
      isSelected: isSelected,
    );
  }
}