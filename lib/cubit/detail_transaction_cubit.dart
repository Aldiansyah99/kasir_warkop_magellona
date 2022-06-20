import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:si_pos/models/api_return_value.dart';
import 'package:si_pos/models/transaction.dart';
import 'package:si_pos/services/services.dart';

part 'detail_transaction_state.dart';

class DetailTransactionCubit extends Cubit<DetailTransactionState> {
  DetailTransactionCubit() : super(DetailTransactionInitial());

  Future<void> getDetailTransaction(int id) async {
    emit(DetailTransactionLoading());
    ApiReturnValue<MDetailTransaction> result =
        await TransactionService.getDetailTransaction(id);

    if (result.value != null) {
      emit(DetailTransactionLoaded(result.value));
    } else {
      emit(DetailTransactionLoadingFailed(result.message));
    }
  }
}
