import 'package:dongsoop/domain/report/model/report_sanction_status.dart';

class SignInState {
  final bool isLoading;
  final String? errorMessage;
  final String? dialogTitle;
  final String? dialogMessage;
  final ReportSanctionStatus? sanction;

  SignInState({
    required this.isLoading,
    this.errorMessage,
    this.dialogTitle,
    this.dialogMessage,
    this.sanction,
  });

  SignInState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? dialogTitle,
    String? dialogMessage,
    ReportSanctionStatus? sanction,
  }) {
    return SignInState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      dialogTitle: dialogTitle,
      dialogMessage: dialogMessage,
      sanction: sanction,
    );
  }
}
