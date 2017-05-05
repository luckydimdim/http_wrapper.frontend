import 'base_error.dart';

class UnauthorizedError extends BaseError {
  UnauthorizedError([code, details]) : super(code, details);
}
