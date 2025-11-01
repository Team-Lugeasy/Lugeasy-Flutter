abstract class ApiResult<T> {
  const ApiResult();
}

class Success<T> extends ApiResult<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends ApiResult<T> {
  final String message;
  final int? code;
  const Error(this.message, {this.code});
}
