import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

@reflectable
class ExceptionModel extends Object with JsonConverter, MapConverter {
  String details;
  int code;
}
