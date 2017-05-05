import 'base_error.dart';

class NotFoundError extends BaseError {
  NotFoundError([code, details]) : super(code, details);
}
