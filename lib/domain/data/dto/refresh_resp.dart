class RefreshResp {
  RefreshResp.fromJson(Map<String, dynamic> json)
      : sessionId = json['sessionId'],
        refreshToken = json['refresh_token'];
  String sessionId;
  String refreshToken;
}
