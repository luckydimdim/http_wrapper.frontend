import 'base_error.dart';

class NonCriticalError extends BaseError {
  NonCriticalError([code, details]) : super(code, details);
}
