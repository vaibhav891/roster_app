import 'dart:convert';

import 'package:http/http.dart';
import 'package:roster_app/data/core/api_constants.dart';

class ApiClient {
  final Client _client;

  ApiClient(this._client);

  dynamic get(String path, Map<String, String> headers) async {
    String url = '${ApiConstants.BASE_URL}$path';
    print('$url  -> $headers');
    final response = await _client.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  dynamic post(String path, String body, Map<String, String> headers) async {
    String endpoint = '${ApiConstants.BASE_URL}$path';
    print(endpoint);
    print(headers);

    final response = await _client.post(endpoint, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody;
    } else if (response.statusCode == 400) {
      print(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    } else if (response.statusCode == 401) {
      print(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }
}
