class EMOModel {
  String? id;
  String? emoValue;
  String? message;
  String? commission;
  String? amountToBeCollected;
  String? senderName;
  String? senderAddress;
  String? senderPinCode;
  String? senderCity;
  String? senderState;
  String? senderMobileNumber;
  String? senderEmail;
  String? payeeName;
  String? payeeAddress;
  String? payeePinCode;
  String? payeeCity;
  String? payeeState;
  String? payeeMobileNumber;
  String? payeeEmail;
  String? type;
  String? date;

  EMOModel(
      this.id,
      this.emoValue,
      this.message,
      this.commission,
      this.amountToBeCollected,
      this.senderName,
      this.senderAddress,
      this.senderPinCode,
      this.senderCity,
      this.senderState,
      this.senderMobileNumber,
      this.senderEmail,
      this.payeeName,
      this.payeeAddress,
      this.payeePinCode,
      this.payeeCity,
      this.payeeState,
      this.payeeMobileNumber,
      this.payeeEmail,
      this.type,
      this.date);

  EMOModel.fromDB(Map<String, dynamic> db) {
    id = db['emoId'];
    emoValue = db['EMOValue'];
    message = db['Message'];
    commission = db['Commission'];
    amountToBeCollected = db['EMOAmount'];
    senderName = db['SenderName'];
    senderAddress = db['SenderAddress'];
    senderPinCode = db['SenderPincode'];
    senderCity = db['SenderCity'];
    senderState = db['SenderState'];
    senderMobileNumber = db['SenderMobileNumber'];
    senderEmail = db['SenderEmail'];
    payeeName = db['PayeeName'];
    payeeAddress = db['PayeeAddress'];
    payeePinCode = db['PayeePincode'];
    payeeCity = db['PayeeCity'];
    payeeState = db['PayeeState'];
    payeeMobileNumber = db['PayeeMobileNumber'];
    payeeEmail = db['PayeeEmail'];
    type = db['Type'];
    date = db['RemarkDate'];
  }
}
