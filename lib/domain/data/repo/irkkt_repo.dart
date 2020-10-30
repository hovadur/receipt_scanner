import 'dart:convert';
import 'dart:io' show HttpStatus, Platform;

import 'package:ctr/domain/data/api/irkkt_api.dart';
import 'package:ctr/domain/data/dto/auth_resp.dart';
import 'package:ctr/domain/data/dto/refresh_resp.dart';
import 'package:ctr/domain/data/dto/ticket_id_resp.dart';
import 'package:ctr/domain/data/dto/ticket_resp.dart';
import 'package:ctr/domain/data/error/irkkt_not_auth.dart';
import 'package:ctr/domain/data/error/irkkt_not_login.dart';
import 'package:ctr/domain/entity/receipt.dart';
import 'package:device_info/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IrkktRepo {
  static const String sessionIdKey = "sessionId";
  static const String refreshTokenKey = "refreshTokenKey";

  //final sessionId =
  //    "5f6a49ff0b851a7cd267a068:64587ce3-b36d-434f-8fa6-5797365e01f4";
  final secret = "IyvrAbKt9h/8p6a7QPh8gpkXYQ4=";
  final api = IrkktApi();

  Future<void> login(String inn, String pass) async {
    var json =
        jsonEncode({"inn": inn, "password": pass, "client_secret": secret});
    var deviceId = await _getId();
    var response = await api.login(json, deviceId);
    if (response.statusCode == HttpStatus.ok) {
      var responseJson = jsonDecode(response.body);
      var value = AuthResp.fromJson(responseJson as Map<String, dynamic>);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(sessionIdKey, value.sessionId);
      await prefs.setString(refreshTokenKey, value.refreshToken);
    } else
      throw IrkktNotLogin();
  }

  Future<void> refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(sessionIdKey);
    var refreshToken = prefs.getString(refreshTokenKey);
    if (sessionId == null && refreshToken == null) {
      throw IrkktNotLogin();
    }
    var json =
        jsonEncode({"refresh_token": refreshToken, "client_secret": secret});
    var deviceId = await _getId();
    var response = await api.refresh(json, deviceId);
    if (response.statusCode == HttpStatus.ok) {
      var responseJson = jsonDecode(response.body);
      var value = RefreshResp.fromJson(responseJson as Map<String, dynamic>);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(sessionIdKey, value.sessionId);
      await prefs.setString(refreshTokenKey, value.refreshToken);
    } else
      throw IrkktNotLogin();
  }

  Future<Receipt> getTicket(String qr) async {
    try {
      return await _getTicket(qr);
    } on IrkktNotAuth {
      await refresh();
      return await _getTicket(qr);
    }
  }

  Future<Receipt> _getTicket(String qr) async {
    var json = jsonEncode({"qr": qr});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(sessionIdKey);
    var response = await api.getTicketId(json, sessionId);
    if (response.statusCode == HttpStatus.ok) {
      var responseJson = jsonDecode(response.body);
      var deviceId = await _getId();
      TicketIdResp ticketId =
          TicketIdResp.fromJson(responseJson as Map<String, dynamic>);
      response = await api.getTicket(ticketId.id, sessionId, deviceId);
      if (response.statusCode == HttpStatus.ok) {
        responseJson = jsonDecode(response.body);
        TicketKktResp ticket =
            TicketKktResp.fromJson(responseJson as Map<String, dynamic>);
        return Receipt.fromTicketResp(ticket);
      } else
        throw Exception('Request failed with status: ${response.statusCode}.' +
            response.body);
    } else if (response.statusCode == HttpStatus.unauthorized) {
      throw IrkktNotAuth();
    } else
      throw Exception('Request failed with status: ${response.statusCode}.' +
          response.body);
  }

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }
}
