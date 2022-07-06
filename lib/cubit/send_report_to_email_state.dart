part of 'send_report_to_email_cubit.dart';

abstract class SendReportToEmailState extends Equatable {
  const SendReportToEmailState();

  @override
  List<Object> get props => [];
}

class SendReportToEmailInitial extends SendReportToEmailState {}

class SendReportToEmailLoaded extends SendReportToEmailState {
  final int statusCode;

  SendReportToEmailLoaded(this.statusCode);

  @override
  List<Object> get props => [statusCode];
}

class SendReportToEmailLoading extends SendReportToEmailState {
  @override
  List<Object> get props => [];
}

class SendReportToEmailLoadingFailed extends SendReportToEmailState {
  final String message;

  SendReportToEmailLoadingFailed(this.message);

  @override
  List<Object> get props => [message];
}
