import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:si_pos/models/api_return_value.dart';
import 'package:si_pos/services/services.dart';

part 'done_transaction_state.dart';

class DoneTransactionCubit extends Cubit<DoneTransactionState> {
  DoneTransactionCubit() : super(DoneTransactionInitial());

  Future<void> doneTransaction({int id, String bayar, String kembalian}) async {
    emit(DoneTransactionLoading());
    ApiReturnValue<String> result = await TransactionService.doneTransaction(
        id: id, bayar: bayar, kembalian: kembalian);

    if (result.value != null) {
      emit(DoneTransactionLoaded(result.value));
    } else {
      emit(DoneTransactionLoadingFailed(result.message));
    }
  }
}
