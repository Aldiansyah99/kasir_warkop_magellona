import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:si_pos/models/api_return_value.dart';
import 'package:si_pos/services/services.dart';

part 'send_report_to_email_state.dart';

class SendReportToEmailCubit extends Cubit<SendReportToEmailState> {
  SendReportToEmailCubit() : super(SendReportToEmailInitial());

  Future<void> sendReportToEmail() async {
    emit(SendReportToEmailLoading());
    ApiReturnValue<int> result = await TransactionService.sendReportToEmail();

    if (result.statusCode == 200) {
      emit(SendReportToEmailLoaded(result.statusCode));
    } else {
      emit(SendReportToEmailLoadingFailed(result.message));
    }
  }
}
