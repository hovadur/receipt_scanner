class TicketKktResp {
  TicketKktResp.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        status = json['status'],
        kkt = json['kkt'],
        createdAt = json['createdAt'],
        qr = json['qr'],
        operation = OperationResp.fromJson(json['operation']),
        seller = json.containsKey('seller')
            ? SellerResp.fromJson(json['seller'])
            : SellerResp(),
        process = (json['process'] as List)
            .map((e) => ProcessResp.fromJson(e))
            .toList(),
        query = QueryResp.fromJson(json['query']),
        ticket = json.containsKey('ticket')
            ? TicketResp.fromJson(json['ticket'])
            : TicketResp(DocumentResp()),
        organization = json.containsKey('organization')
            ? SellerResp.fromJson(json['organization'])
            : SellerResp();
  String id;
  int status;
  String kkt;
  String createdAt;
  String qr;
  OperationResp operation;
  SellerResp seller;
  List<ProcessResp> process;
  QueryResp query;
  TicketResp ticket;
  SellerResp organization;
}

class TicketResp {
  TicketResp(this.document);

  TicketResp.fromJson(Map<String, dynamic> json)
      : document = DocumentResp.fromJson(json['document']);
  DocumentResp document;
}

class DocumentResp {
  DocumentResp({this.receipt});

  DocumentResp.fromJson(Map<String, dynamic> json)
      : receipt = ReceiptResp.fromJson(json['receipt']);
  ReceiptResp? receipt;
}

class ReceiptResp {
  ReceiptResp.fromJson(Map<String, dynamic> json)
      : dateTime = json['dateTime'],
        addressToCheckFiscalSign = json['addressToCheckFiscalSign'],
        buyerAddress = json['buyerAddress'],
        cashTotalSum = json['cashTotalSum'],
        ecashTotalSum = json['ecashTotalSum'],
        fiscalDocumentNumber = json['fiscalDocumentNumber'],
        fiscalDriveNumber = json['fiscalDriveNumber'],
        fiscalSign = json['fiscalSign'],
        items =
            (json['items'] as List).map((e) => ItemsResp.fromJson(e)).toList(),
        kktRegId = json['kktRegId'],
        nds18 = json['nds18'],
        operationType = json['operationType'],
        operator = json['operator'],
        receiptCode = json['receiptCode'],
        requestNumber = json['requestNumber'],
        retailPlaceAddress = json['retailPlaceAddress'],
        senderAddress = json['senderAddress'],
        shiftNumber = json['shiftNumber'],
        taxationType = json['taxationType'],
        totalSum = json['totalSum'],
        user = json['user'],
        userInn = json['userInn'];
  int dateTime;
  String addressToCheckFiscalSign;
  String buyerAddress;
  int cashTotalSum;
  int ecashTotalSum;
  int fiscalDocumentNumber;
  String fiscalDriveNumber;
  int fiscalSign;
  List<ItemsResp> items;
  String kktRegId;
  int nds18;
  int operationType;
  String operator;
  int receiptCode;
  int requestNumber;
  String retailPlaceAddress;
  String senderAddress;
  int shiftNumber;
  int taxationType;
  int totalSum;
  String user;
  String userInn;
}

class ItemsResp {
  ItemsResp.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        price = json['price'],
        quantity = json['quantity'],
        sum = json['sum'];
  String name;
  int price;
  num quantity;
  int sum;
}

class OperationResp {
  OperationResp.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        type = json['type'],
        sum = json['sum'];
  String date;
  int type;
  int sum;
}

class SellerResp {
  SellerResp({this.name = '', this.inn = ''});

  static SellerResp fromJson(Map<String, dynamic> json) {
    final name = json.containsKey('name') ? json['name'] : '';
    final inn = json.containsKey('inn') ? json['inn'] : '';
    return SellerResp(name: name, inn: inn);
  }

  String name;
  String inn;
}

class ProcessResp {
  ProcessResp.fromJson(Map<String, dynamic> json)
      : time = json['time'],
        result = json['result'];
  String time;
  int result;
}

class QueryResp {
  QueryResp.fromJson(Map<String, dynamic> json)
      : operationType = json['operationType'],
        sum = json['sum'],
        documentId = json['documentId'],
        fsId = json['fsId'],
        fiscalSign = json['fiscalSign'],
        date = json['date'];
  int operationType;
  int sum;
  int documentId;
  String fsId;
  String fiscalSign;
  String date;
}
