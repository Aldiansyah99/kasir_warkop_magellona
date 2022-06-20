import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:si_pos/services/services.dart';

import '../models/api_return_value.dart';

part 'delete_product_transaction_state.dart';

class DeleteProductTransactionCubit
    extends Cubit<DeleteProductTransactionState> {
  DeleteProductTransactionCubit() : super(DeleteProductTransactionInitial());

  Future<void> deleteProductTransaction(int id) async {
    emit(DeleteProductTransactionLoading());
    ApiReturnValue<String> result =
        await TransactionService.deleteProductTransaction(id);

    if (result.value != null) {
      emit(DeleteProductTransactionLoaded(result.value));
    } else {
      emit(DeleteProductTransactionLoadingFailed(result.message));
    }
  }
}
