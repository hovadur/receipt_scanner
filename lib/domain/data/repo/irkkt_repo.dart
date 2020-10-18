import 'dart:convert';
import 'dart:io' show Platform;

import 'package:ctr/domain/data/dto/ticket_resp.dart';
import 'package:ctr/domain/data/dto/ticket_id_resp.dart';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;

class IrkktRepo {
  static const String host = "https://irkkt-mobile.nalog.ru:8888/v2/";

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

  Future<TicketKktResp> getTicket(String qr) async {
    final sessionId =
        "5f6a49ff0b851a7cd267a068:f587974f-d30c-4629-9c03-b96242f04b6e";
    var jsonQr = jsonEncode({"qr": qr});
    var response = await http.post(host + "ticket",
        headers: {"Content-Type": "application/json", "sessionId": sessionId},
        body: jsonQr);
    var responseJson = jsonDecode(response.body);
    var deviceId = await _getId();
    TicketIdResp ticketId =
        TicketIdResp.fromJson(responseJson as Map<String, dynamic>);
    response = await http.get(host + "tickets/" + ticketId.id, headers: {
      "Device-OS": Platform.operatingSystem,
      "Device-Id": deviceId,
      "sessionId": sessionId
    });
    responseJson = jsonDecode(response.body);
    TicketKktResp ticket =
        TicketKktResp.fromJson(responseJson as Map<String, dynamic>);
    return ticket;
  }
}
