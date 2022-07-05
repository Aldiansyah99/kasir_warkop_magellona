import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:si_pos/models/api_return_value.dart';
import 'package:si_pos/services/services.dart';

part 'send_invoice_state.dart';

class SendInvoiceCubit extends Cubit<SendInvoiceState> {
  SendInvoiceCubit() : super(SendInvoiceInitial());

  Future<void> sendInvoice({String id, String email}) async {
    emit(SendInvoiceLoading());
    ApiReturnValue<int> result =
        await TransactionService.sendInvoice(id: id, email: email);

    if (result.statusCode == 200) {
      emit(SendInvoiceLoaded(result.statusCode));
    } else {
      emit(SendInvoiceLoadingFailed(result.message));
    }
  }
}
