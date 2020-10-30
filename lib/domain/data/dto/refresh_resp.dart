class RefreshResp {
  String sessionId;
  String refreshToken;

  RefreshResp.fromJson(Map<String, dynamic> json)
      : sessionId = json['sessionId'],
        refreshToken = json['refresh_token'];
}
