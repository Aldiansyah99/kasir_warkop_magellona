part of 'send_invoice_cubit.dart';

abstract class SendInvoiceState extends Equatable {
  const SendInvoiceState();

  @override
  List<Object> get props => [];
}

class SendInvoiceInitial extends SendInvoiceState {}

class SendInvoiceLoaded extends SendInvoiceState {
  final int statusCode;

  SendInvoiceLoaded(this.statusCode);

  @override
  List<Object> get props => [statusCode];
}

class SendInvoiceLoading extends SendInvoiceState {
  @override
  List<Object> get props => [];
}

class SendInvoiceLoadingFailed extends SendInvoiceState {
  final String message;

  SendInvoiceLoadingFailed(this.message);

  @override
  List<Object> get props => [message];
}
