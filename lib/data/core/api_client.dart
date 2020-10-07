import 'dart:convert';

import 'package:http/http.dart';
import 'package:roster_app/data/core/api_constants.dart';

class ApiClient {
  final Client _client;

  ApiClient(this._client);

  dynamic get(String path) async {
    final response = await _client.get(
      '${ApiConstants.BASE_URL}$path?api_key=${ApiConstants.API_KEY}',
      headers: {
        'content-type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  dynamic post(String path, String body) async {
    Map<String, String> headers = {'Content-Type': 'application/json', 'App_Name': ApiConstants.APP_NAME};

    // final response = await _client.post('${ApiConstants.BASE_URL}$path', headers: headers, body: body);

    final responseBody = {
      "type": "Bearer",
      "token":
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJST1NURVJBUFAiLCJkYXRhIjp7InB1YmxpYyI6eyJ1c2VyIjoiU29maWEiLCJyb2xlIjoidXNlciJ9LCJlbmNEYXRhIjoiNGJmYjJkNTI3MWU0ZjA4ZjYwZDU5NjkzYzVkMmIyODQ0NDg1ODJlNjc2Mzk1MmViYTM2YzdjMjQ2YmViOTBlMyJ9LCJpYXQiOjE2MDE5NjQ4NDYsImV4cCI6MTYwNDU1Njg0Nn0.45PbwjaCEPbiJ0T81j0RnU2bP-zy1E-A5rc8l10MtOE",
      "isFirstLogin": true
    };
    return responseBody;
    //throw Exception('error response');

    // if (response.statusCode == 200) {
    //   final responseBody = jsonDecode(response.body);
    //   return responseBody;
    // } else if(response.statusCode == 400){
    //   throw Exception(response.reasonPhrase);
    // } else if(response.statusCode == 401){
    //   throw Exception(response.reasonPhrase);

    //}
  }
}
