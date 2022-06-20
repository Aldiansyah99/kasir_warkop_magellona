part of 'report_cubit.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoaded extends ReportState {
  final Report report;

  ReportLoaded(this.report);

  @override
  List<Object> get props => [report];
}

class ReportLoading extends ReportState {
  @override
  List<Object> get props => [];
}

class ReportLoadingFailed extends ReportState {
  final String message;

  ReportLoadingFailed(this.message);

  @override
  List<Object> get props => [message];
}
