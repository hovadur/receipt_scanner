class TicketKktResp {
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

  TicketKktResp.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        status = json['status'],
        kkt = json['kkt'],
        createdAt = json['createdAt'],
        qr = json['qr'],
        operation = OperationResp.fromJson(json['operation']),
        seller = SellerResp.fromJson(json['seller']),
        process = (json['process'] as List)
            ?.map((e) => e == null ? null : ProcessResp.fromJson(e))
            ?.toList(),
        query = QueryResp.fromJson(json['query']),
        ticket = TicketResp.fromJson(json['ticket']),
        organization = SellerResp.fromJson(json['organization']);
}

class TicketResp {
  DocumentResp document;

  TicketResp.fromJson(Map<String, dynamic> json)
      : document = DocumentResp.fromJson(json['document']);
}

class DocumentResp {
  ReceiptResp receipt;

  DocumentResp.fromJson(Map<String, dynamic> json)
      : receipt = ReceiptResp.fromJson(json['receipt']);
}

class ReceiptResp {
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

  ReceiptResp.fromJson(Map<String, dynamic> json)
      : dateTime = json['dateTime'],
        addressToCheckFiscalSign = json['addressToCheckFiscalSign'],
        buyerAddress = json['buyerAddress'],
        cashTotalSum = json['cashTotalSum'],
        ecashTotalSum = json['addressToCheckFiscalSign'],
        fiscalDocumentNumber = json['fiscalDocumentNumber'],
        fiscalDriveNumber = json['fiscalDriveNumber'],
        fiscalSign = json['fiscalSign'],
        items = (json['items'] as List)
            ?.map((e) => e == null ? null : ItemsResp.fromJson(e))
            ?.toList(),
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
}

class ItemsResp {
  String name;
  int price;
  int quantity;
  int sum;

  ItemsResp.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        price = json['price'],
        quantity = json['quantity'],
        sum = json['sum'];
}

class OperationResp {
  String date;
  int type;
  int sum;

  OperationResp.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        type = json['type'],
        sum = json['sum'];
}

class SellerResp {
  String name;
  String inn;

  SellerResp.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        inn = json['inn'];
}

class ProcessResp {
  String time;
  int result;

  ProcessResp.fromJson(Map<String, dynamic> json)
      : time = json['time'],
        result = json['result'];
}

class QueryResp {
  int operationType;
  int sum;
  int documentId;
  String fsId;
  String fiscalSign;
  String date;

  QueryResp.fromJson(Map<String, dynamic> json)
      : operationType = json['operationType'],
        sum = json['sum'],
        documentId = json['documentId'],
        fsId = json['fsId'],
        fiscalSign = json['fiscalSign'],
        date = json['date'];
}
