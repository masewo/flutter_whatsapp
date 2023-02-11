import 'dart:async';

import 'package:flutter_whatsapp/src/models/call_list.dart';
import 'package:flutter_whatsapp/src/services/api.dart';
import 'package:http/http.dart' as http;

String url = '$apiEndpoint/api/calls';

class CallService {
  static Future<CallList> getCalls() async {
    final response = await http.get(Uri.parse(url));
    return callListFromJson(response.body);
  }
}
