class ApiReturnValue<T> {
  final T value;
  final String message;
  final int statusCode;

  ApiReturnValue({this.message, this.value, this.statusCode});
}
