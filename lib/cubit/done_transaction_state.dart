part of 'done_transaction_cubit.dart';

abstract class DoneTransactionState extends Equatable {
  const DoneTransactionState();

  @override
  List<Object> get props => [];
}

class DoneTransactionInitial extends DoneTransactionState {}

class DoneTransactionLoaded extends DoneTransactionState {
  final String message;

  DoneTransactionLoaded(this.message);

  @override
  List<Object> get props => [message];
}

class DoneTransactionLoading extends DoneTransactionState {
  @override
  List<Object> get props => [];
}

class DoneTransactionLoadingFailed extends DoneTransactionState {
  final String message;

  DoneTransactionLoadingFailed(this.message);

  @override
  List<Object> get props => [message];
}
