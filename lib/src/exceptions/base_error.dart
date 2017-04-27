class BaseError implements Exception {
  String details;
  int code;

  BaseError([this.code, this.details]);
}
