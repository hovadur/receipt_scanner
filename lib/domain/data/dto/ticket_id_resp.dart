class TicketIdResp {
  TicketIdResp.fromJson(Map<String, dynamic> json)
      : kind = json['kind'],
        id = json['id'],
        status = json['status'];
  String kind;
  String id;
  int status;
}
