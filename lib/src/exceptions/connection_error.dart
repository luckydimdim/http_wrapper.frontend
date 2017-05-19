import 'base_error.dart';

class ConnectionError extends BaseError {
  ConnectionError([code, details]) : super(code, details);
}
