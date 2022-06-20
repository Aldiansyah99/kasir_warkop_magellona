part of 'detail_transaction_cubit.dart';

abstract class DetailTransactionState extends Equatable {
  const DetailTransactionState();

  @override
  List<Object> get props => [];
}

class DetailTransactionInitial extends DetailTransactionState {}

class DetailTransactionLoaded extends DetailTransactionState {
  final MDetailTransaction transaction;

  DetailTransactionLoaded(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class DetailTransactionLoading extends DetailTransactionState {
  @override
  List<Object> get props => [];
}

class DetailTransactionLoadingFailed extends DetailTransactionState {
  final String message;

  DetailTransactionLoadingFailed(this.message);

  @override
  List<Object> get props => [message];
}
