import 'dart:async';
import 'package:http/http.dart';
import 'exceptions/unauthorized_error.dart';
import 'package:auth/auth_service.dart';

class HttpWrapper {
  final Client _http;
  final AuthenticationService _authenticationService;

  HttpWrapper(this._http, this._authenticationService) {}

  Future<Response> get(url,
      {Map<String, String> headers, useAuth: true}) async {
    if (useAuth) {
      if (!_authenticationService.isAuth()) {
        throw new UnauthorizedError();
      }

      headers["Authorization"] = _authenticationService.getToken();
    }

    var response = await _http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 401) {
      // Unauthorized
      throw new UnauthorizedError();
    } else {
      throw new Exception('Unknown HTTP error');
    }
  }
}
