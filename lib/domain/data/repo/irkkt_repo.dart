import 'dart:convert';
import 'dart:io' show HttpStatus, Platform;

import 'package:ctr/domain/data/api/irkkt_api.dart';
import 'package:ctr/domain/data/dto/auth_resp.dart';
import 'package:ctr/domain/data/dto/refresh_resp.dart';
import 'package:ctr/domain/data/dto/ticket_id_resp.dart';
import 'package:ctr/domain/data/dto/ticket_resp.dart';
import 'package:ctr/domain/data/error/irkkt_not_auth.dart';
import 'package:ctr/domain/data/error/irkkt_not_login.dart';
import 'package:ctr/domain/data/repo/settings_repo.dart';
import 'package:ctr/domain/entity/receipt.dart';
import 'package:device_info/device_info.dart';

class IrkktRepo {
  IrkktRepo(this._api, this._settingsRepo);

  final secret = 'IyvrAbKt9h/8p6a7QPh8gpkXYQ4=';
  final IrkktApi _api;
  final SettingsRepo _settingsRepo;

  Future<void> login(String inn, String pass) async {
    final json =
        jsonEncode({'inn': inn, 'password': pass, 'client_secret': secret});
    final deviceId = await _getId();
    final response = await _api.login(json, deviceId);
    if (response.statusCode == HttpStatus.ok) {
      final responseJson = jsonDecode(response.body);
      final value = AuthResp.fromJson(responseJson as Map<String, dynamic>);
      await _settingsRepo.setSessionId(value.sessionId);
      await _settingsRepo.setRefreshToken(value.refreshToken);
    } else {
      throw IrkktNotLogin();
    }
  }

  Future<void> refresh() async {
    final sessionId = _settingsRepo.getSessionId();
    final refreshToken = _settingsRepo.getRefreshToken();
    if (sessionId.isEmpty && refreshToken.isEmpty) {
      throw IrkktNotLogin();
    }
    final json =
        jsonEncode({'refresh_token': refreshToken, 'client_secret': secret});
    final deviceId = await _getId();
    final response = await _api.refresh(json, deviceId);
    if (response.statusCode == HttpStatus.ok) {
      final responseJson = jsonDecode(response.body);
      final value = RefreshResp.fromJson(responseJson as Map<String, dynamic>);
      await _settingsRepo.setSessionId(value.sessionId);
      await _settingsRepo.setRefreshToken(value.refreshToken);
    } else {
      throw IrkktNotLogin();
    }
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
    final json = jsonEncode({'qr': qr});
    final sessionId = _settingsRepo.getSessionId();
    var response = await _api.getTicketId(json, sessionId);
    if (response.statusCode == HttpStatus.ok) {
      var responseJson = jsonDecode(response.body);
      final deviceId = await _getId();
      final ticketId =
          TicketIdResp.fromJson(responseJson as Map<String, dynamic>);
      response = await _api.getTicket(ticketId.id, sessionId, deviceId);
      if (response.statusCode == HttpStatus.ok) {
        responseJson = jsonDecode(response.body);
        final ticket =
            TicketKktResp.fromJson(responseJson as Map<String, dynamic>);
        return Receipt.fromTicketResp(ticket);
      } else {
        throw Exception(
            '${'Request failed with status: ${response.statusCode}.'}'
            '${response.body}');
      }
    } else if (response.statusCode == HttpStatus.unauthorized) {
      throw IrkktNotAuth();
    } else {
      throw Exception('${'Request failed with status: ${response.statusCode}.'}'
          '${response.body}');
    }
  }

  Future<String> _getId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      final androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }
}
