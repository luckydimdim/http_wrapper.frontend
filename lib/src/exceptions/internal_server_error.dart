import 'base_error.dart';

class InternalServerError extends BaseError {
  InternalServerError([code, details]) : super(code, details);
}
