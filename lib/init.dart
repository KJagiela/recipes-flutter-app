import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class Init {
  static List<String> categories = [];

  static Future initialize() async {
    categories = await _initData();
  }

  static _initData() async {
    final url = Uri.http('10.0.2.2:8000', 'categories/');
    http.Response response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Basic a2FzaWE6a2FzaWE=',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
        }
    ); // tODO: connector class
    return jsonDecode(response.body);
  }

}