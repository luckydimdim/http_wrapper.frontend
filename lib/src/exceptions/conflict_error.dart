import 'base_error.dart';

class ConflictError extends BaseError {
  ConflictError([code, details]) : super(code, details);
}
