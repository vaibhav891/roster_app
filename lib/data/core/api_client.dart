import 'dart:convert';

import 'package:http/http.dart';
import 'package:roster_app/data/core/api_constants.dart';

class ApiClient {
  final Client _client;

  ApiClient(this._client);

  dynamic get(String path, Map<String, String> headers) async {
    String url = '${ApiConstants.BASE_URL}$path';
    var responseBody;

    print(url);
    print(headers);

    final response = await _client.get(
      url,
      headers: headers,
    );
    print(response.body);
    responseBody = _returnResponse(response);

    return responseBody;
  }

  dynamic post(String path, String body, Map<String, String> headers) async {
    String endpoint = '${ApiConstants.BASE_URL}$path';
    var responseBody;
    print(endpoint);
    print(headers);

    final response = await _client.post(endpoint, headers: headers, body: body);
    print(response.body);
    responseBody = _returnResponse(response);

    return responseBody;
  }

  dynamic _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 201:
      case 204:
        return response.body.toString();
      case 400:
        var responseJson = json.decode(response.body.toString());
        throw InvalidInputException(responseJson["problems"][0]);
      case 401:
      case 403:
      case 404:
        var responseJson = json.decode(response.body.toString());
        throw InvalidInputException(responseJson["problems"][0]);
      case 500:
      default:
        throw Exception('Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String message]) : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String message]) : super(message, "Error: ");
}
