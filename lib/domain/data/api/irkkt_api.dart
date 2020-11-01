import 'dart:io' show Platform;

import 'package:http/http.dart';

class IrkktApi {
  static const String host = 'https://irkkt-mobile.nalog.ru:8888/v2/';
  final _client = Client();

  Future<Response> login(String json, String deviceId) async =>
      _client.post('${host}mobile/users/lkfl/auth',
          headers: {
            'Content-Type': 'application/json',
            'Device-OS': Platform.operatingSystem,
            'Device-Id': deviceId
          },
          body: json);

  Future<Response> getTicketId(String json, String sessionId) async =>
      _client.post('${host}ticket',
          headers: {'Content-Type': 'application/json', 'sessionId': sessionId},
          body: json);

  Future<Response> getTicket(
          String id, String sessionId, String deviceId) async =>
      _client.get('${host}tickets/$id', headers: {
        'Device-OS': Platform.operatingSystem,
        'Device-Id': deviceId,
        'sessionId': sessionId
      });

  Future<Response> refresh(String json, String deviceId) async =>
      _client.post('${host}mobile/users/refresh', headers: {
        'Content-Type': 'application/json',
        'Device-OS': Platform.operatingSystem,
        'Device-Id': deviceId
      });
}
