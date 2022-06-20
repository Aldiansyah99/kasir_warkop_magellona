part of 'delete_product_transaction_cubit.dart';

abstract class DeleteProductTransactionState extends Equatable {
  const DeleteProductTransactionState();

  @override
  List<Object> get props => [];
}

class DeleteProductTransactionInitial extends DeleteProductTransactionState {}

class DeleteProductTransactionLoaded extends DeleteProductTransactionState {
  final String message;

  DeleteProductTransactionLoaded(this.message);

  @override
  List<Object> get props => [message];
}

class DeleteProductTransactionLoading extends DeleteProductTransactionState {
  @override
  List<Object> get props => [];
}

class DeleteProductTransactionLoadingFailed
    extends DeleteProductTransactionState {
  final String message;

  DeleteProductTransactionLoadingFailed(this.message);

  @override
  List<Object> get props => [message];
}
