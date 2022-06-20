import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:si_pos/models/api_return_value.dart';
import 'package:si_pos/models/transaction.dart';
import 'package:si_pos/services/services.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit() : super(TransactionInitial());

  Future<void> getTransaction() async {
    emit(TransactionLoading());
    ApiReturnValue<DataTransaction> result =
        await TransactionService.getListTransaction();

    if (result.value != null) {
      emit(TransactionLoaded(result.value));
    } else {
      emit(TransactionLoadingFailed(result.message));
    }
  }
}
