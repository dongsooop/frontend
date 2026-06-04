class PasswordResetState {
  final bool isLoading;
  final String? errorMessage;
  final PasswordResetEmailValidationState email;
  final PasswordResetEmailVerificationCodeState emailCode;
  final PasswordResetValidationState password;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isEmailStep;

  PasswordResetState({
    required this.isLoading,
    this.errorMessage,
    required this.email,
    required this.emailCode,
    required this.password,
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.isEmailStep,
  });

  PasswordResetState copyWith({
    bool? isLoading,
    String? errorMessage,
    PasswordResetEmailValidationState? email,
    PasswordResetEmailVerificationCodeState? emailCode,
    PasswordResetValidationState? password,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isEmailStep,
  }) {
    return PasswordResetState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      email: email ?? this.email,
      emailCode: emailCode ?? this.emailCode,
      password: password ?? this.password,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isEmailStep: isEmailStep ?? this.isEmailStep,
    );
  }
}

class PasswordResetEmailValidationState {
  final String? email;
  final bool? isFormatValid;
  final bool? isDuplicate;
  final String? message;
  final bool? isError;
  final bool isLoading;

  PasswordResetEmailValidationState({
    this.email,
    this.isFormatValid,
    this.isDuplicate,
    this.message,
    this.isError,
    required this.isLoading,
  });

  PasswordResetEmailValidationState copyWith({
    String? email,
    bool? isFormatValid,
    bool? isDuplicate,
    String? message,
    bool? isError,
    bool? isLoading,
  }) {
    return PasswordResetEmailValidationState(
      email: email ?? this.email,
      isFormatValid: isFormatValid ?? this.isFormatValid,
      isDuplicate: isDuplicate ?? this.isDuplicate,
      message: message ?? this.message,
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PasswordResetEmailVerificationCodeState {
  final bool? isTimerRunning;
  final int? remainingSeconds;
  final bool? isChecked;
  final String? message;
  final bool? isError;
  final bool isCodeLoading;
  final bool isCheckLoading;
  final int failCount;

  PasswordResetEmailVerificationCodeState({
    this.isTimerRunning,
    this.remainingSeconds,
    this.isChecked,
    this.message,
    this.isError,
    required this.isCodeLoading,
    required this.isCheckLoading,
    this.failCount = 0,
  });

  PasswordResetEmailVerificationCodeState copyWith({
    bool? isTimerRunning,
    int? remainingSeconds,
    bool? isChecked,
    String? message,
    bool? isError,
    bool? isCodeLoading,
    bool? isCheckLoading,
    int? failCount,
  }) {
    return PasswordResetEmailVerificationCodeState(
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isChecked: isChecked,
      message: message ?? this.message,
      isError: isError ?? this.isError,
      isCodeLoading: isCodeLoading ?? this.isCodeLoading,
      isCheckLoading: isCheckLoading ?? this.isCheckLoading,
      failCount: failCount ?? this.failCount,
    );
  }
}

class PasswordResetValidationState {
  final String? password;
  final bool? isEnglishValid;
  final bool? isNumberFormatValid; // 숫자 포함?
  final bool? isSpecialCharacterValid; // 특수문자
  final bool? isChecked; // null: 검사 안함, true: 사용 가능, false: 불일치
  final String? message;
  final bool? isError;

  PasswordResetValidationState({
    this.password,
    this.isEnglishValid,
    this.isNumberFormatValid,
    this.isSpecialCharacterValid,
    this.isChecked,
    this.message,
    this.isError,
  });

  PasswordResetValidationState copyWith({
    String? password,
    bool? isEnglishValid,
    bool? isNumberFormatValid,
    bool? isSpecialCharacterValid,
    bool? isChecked,
    String? message,
    bool? isError,
  }) {
    return PasswordResetValidationState(
      password: password,
      isEnglishValid: isEnglishValid,
      isNumberFormatValid: isNumberFormatValid,
      isSpecialCharacterValid: isSpecialCharacterValid,
      isChecked: isChecked,
      message: message,
      isError: isError,
    );
  }
}
