part of 'delete_transaction_cubit.dart';

abstract class DeleteTransactionState extends Equatable {
  const DeleteTransactionState();

  @override
  List<Object> get props => [];
}

class DeleteTransactionInitial extends DeleteTransactionState {}

class DeleteTransactionLoaded extends DeleteTransactionState {
  final String message;

  DeleteTransactionLoaded(this.message);

  @override
  List<Object> get props => [message];
}

class DeleteTransactionLoading extends DeleteTransactionState {
  @override
  List<Object> get props => [];
}

class DeleteTransactionLoadingFailed extends DeleteTransactionState {
  final String message;

  DeleteTransactionLoadingFailed(this.message);

  @override
  List<Object> get props => [message];
}
