import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:si_pos/models/api_return_value.dart';
import 'package:si_pos/models/report.dart';
import 'package:si_pos/services/services.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit() : super(ReportInitial());

  Future<void> getReport() async {
    emit(ReportLoading());
    ApiReturnValue<Report> result = await TransactionService.getReport();

    if (result.value != null) {
      emit(ReportLoaded(result.value));
    } else {
      emit(ReportLoadingFailed(result.message));
    }
  }

  Future<void> filterReport({DateTime from, DateTime until}) async {
    emit(ReportLoading());
    ApiReturnValue<Report> result =
        await TransactionService.filterReport(from: from, until: until);

    if (result.value != null) {
      emit(ReportLoaded(result.value));
    } else {
      emit(ReportLoadingFailed(result.message));
    }
  }
}
