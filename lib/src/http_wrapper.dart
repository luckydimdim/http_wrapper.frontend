import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'exceptions/unauthorized_error.dart';
import 'package:auth/auth_service.dart';

class HttpWrapper {
  final Client _http;
  final AuthenticationService _authenticationService;

  HttpWrapper(this._http, this._authenticationService);

  Future<Response> get(url,
      {Map<String, String> headers, useAuth: true}) async {

    _setAuth(useAuth, headers);

    var response = await _http.get(url, headers: headers);

    _checkResponse(response);

    return response;
  }

  Future<Response> post(url, {Map<String, String> headers, body,
    Encoding encoding, useAuth: true}) async {

    _setAuth(useAuth, headers);

    var response = await _http.post(url, headers: headers, body: body, encoding: encoding);

    _checkResponse(response);

    return response;
  }

  Future<Response> put(url, {Map<String, String> headers, body,
    Encoding encoding, useAuth: true}) async {

    _setAuth(useAuth, headers);

    var response = await _http.put(url, headers: headers, body: body, encoding: encoding);

    _checkResponse(response);

    return response;
  }

  Future<Response> delete(url, {Map<String, String> headers, useAuth: true}) async{
    _setAuth(useAuth, headers);

    var response = await _http.delete(url, headers: headers);

    _checkResponse(response);

    return response;
  }

  void _setAuth(bool useAuth, Map<String, String> headers) {
    if (useAuth) {
      if (!_authenticationService.isAuth()) {
        throw new UnauthorizedError();
      }

      headers["Authorization"] = _authenticationService.getToken();
    }
  }

  void _checkResponse(Response response) {
    if (response.statusCode == 200) {
      // OK
      return;
    } else if (response.statusCode == 401) {
      // Unauthorized
      throw new UnauthorizedError();
    } else {
      throw new Exception('Unknown HTTP error');
    }
  }


}
