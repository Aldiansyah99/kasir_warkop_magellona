import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:si_pos/models/api_return_value.dart';
import 'package:si_pos/services/services.dart';

part 'delete_transaction_state.dart';

class DeleteTransactionCubit extends Cubit<DeleteTransactionState> {
  DeleteTransactionCubit() : super(DeleteTransactionInitial());

  Future<void> deleteTransaction(int id) async {
    emit(DeleteTransactionLoading());
    ApiReturnValue<String> result =
        await TransactionService.deleteTransaction(id);

    if (result.value != null) {
      emit(DeleteTransactionLoaded(result.value));
    } else {
      emit(DeleteTransactionLoadingFailed(result.message));
    }
  }
}
