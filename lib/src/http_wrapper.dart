import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import '../exceptions.dart';
import 'package:auth/auth_service.dart';
import './exceptions/exception_model.dart';

class HttpWrapper {
  final Client _http;
  final AuthenticationService _authenticationService;

  HttpWrapper(this._http, this._authenticationService);

  Future<Response> get(url,
      {Map<String, String> headers, useAuth: true}) async {
    _setAuth(useAuth, headers);

    try {
      var response = await _http.get(url, headers: headers);
    }
    on ClientException catch(e) {
      throw new ConnectionError(null, e.message);
    }

    _checkResponse(response);

    return response;
  }

  Future<Response> post(url,
      {Map<String, String> headers,
      body,
      Encoding encoding,
      useAuth: true}) async {
    _setAuth(useAuth, headers);

    var response =
        await _http.post(url, headers: headers, body: body, encoding: encoding);

    _checkResponse(response);

    return response;
  }

  Future<Response> put(url,
      {Map<String, String> headers,
      body,
      Encoding encoding,
      useAuth: true}) async {
    _setAuth(useAuth, headers);

    var response =
        await _http.put(url, headers: headers, body: body, encoding: encoding);

    _checkResponse(response);

    return response;
  }

  Future<Response> delete(url,
      {Map<String, String> headers, useAuth: true}) async {
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
    }

    ExceptionModel model;

    try {
      dynamic json = JSON.decode(response.body);
      model = new ExceptionModel().fromJson(json);
    } catch (e) {
      // TODO: логирование
    }

    if (response.statusCode == 401) {
      // Unauthorized
      throw new UnauthorizedError(model?.code, model?.details);
    } else if (response.statusCode == 404) {
      // Not Found
      throw new NotFoundError(model?.code, model?.details);
    } else if (response.statusCode == 400) {
      // Bad Request

      if (model == null) {
        throw new Exception(
            'Unknown HTTP error (parsing error). Code:  ${response.statusCode}');
      }

      switch (model.code) {
        case 0:
          throw new GeneralError(model?.code, model?.details);
        case 50:
          throw new ValidationError(model?.code, model?.details);
        default:
          throw new Exception(
              'Unknown HTTP error (unknown subcode ${model.code}). HTTP Code:  ${response.statusCode}');
      }
    } else if (response.statusCode == 500) {
      // Bad Request
      throw new InternalServerError(model?.code, model?.details);
    } else if (response.statusCode == 409) {
      // Conflict
      throw new ConflictError(model?.code, model?.details);
    } else if (response.statusCode == 403) {
      // Forbidden
      throw new ForbiddenError(model?.code, model?.details);
    } else {
      throw new Exception('Unknown HTTP error. Code:  ${response.statusCode}');
    }
  }
}
