class BaseResponse<T> {
  String? message;
  T? data;

  BaseResponse({this.message, this.data});
}
