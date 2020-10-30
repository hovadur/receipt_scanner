class AuthResp {
  String sessionId;
  String refreshToken;
  String name;
  String email;
  String surname;

  AuthResp.fromJson(Map<String, dynamic> json)
      : sessionId = json['sessionId'],
        refreshToken = json['refresh_token'],
        name = json['name'],
        email = json['email'],
        surname = json['surname'];
}
