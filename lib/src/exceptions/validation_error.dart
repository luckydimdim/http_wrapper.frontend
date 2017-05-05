import 'base_error.dart';

class ValidationError extends BaseError {
  ValidationError([code, details]) : super(code, details);
}
