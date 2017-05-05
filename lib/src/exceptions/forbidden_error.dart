import 'base_error.dart';

class ForbiddenError extends BaseError {
  ForbiddenError([code, details]) : super(code, details);
}
