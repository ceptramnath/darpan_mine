class BookingRegisterModel {
  String? articleNumber;
  String? weight;
  String? weightAmount;
  String? prepaidAmount;
  String? acknowledgementAmount;
  String? insuranceAmount;
  String? vppAmount;
  String? registrationFee;
  String? amountToBeCollected;
  String? senderName;
  String? senderAddress;
  String? senderPinCode;
  String? senderCity;
  String? senderState;
  String? senderMobileNumber;
  String? senderEmail;
  String? addresseeName;
  String? addresseeAddress;
  String? addresseePinCode;
  String? addresseeCity;
  String? addresseeState;
  String? addresseeMobileNumber;
  String? addresseeEmail;
  String? date;
  String? time;
  String? status;

  BookingRegisterModel(
      this.articleNumber,
      this.weight,
      this.weightAmount,
      this.prepaidAmount,
      this.acknowledgementAmount,
      this.insuranceAmount,
      this.vppAmount,
      this.registrationFee,
      this.amountToBeCollected,
      this.senderName,
      this.senderAddress,
      this.senderPinCode,
      this.senderCity,
      this.senderState,
      this.senderMobileNumber,
      this.senderEmail,
      this.addresseeName,
      this.addresseeAddress,
      this.addresseePinCode,
      this.addresseeCity,
      this.addresseeState,
      this.addresseeMobileNumber,
      this.addresseeEmail,
      this.date,
      this.time,
      this.status);

  BookingRegisterModel.fromDB(Map<String, dynamic> db) {
    articleNumber = db['ArticleNumber'];
    weight = db['ArticleWeight'];
    weightAmount = db['WeightAmount'];
    prepaidAmount = db['PrepaidAmount'];
    acknowledgementAmount = db['AcknowledgeAmount'];
    insuranceAmount = db['InsuranceAmount'];
    vppAmount = db['VPPAmount'];
    registrationFee = db['RegistrationFee'];
    amountToBeCollected = db['TotalAmount'];
    senderName = db['SenderName'];
    senderAddress = db['SenderAddress'];
    senderPinCode = db['SenderPinCode'];
    senderCity = db['SenderCity'];
    senderState = db['SenderState'];
    senderMobileNumber = db['SenderPhone'];
    senderEmail = db['SenderEmail'];
    addresseeName = db['AddresseeName'];
    addresseeAddress = db['AddresseeAddress'];
    addresseePinCode = db['AddresseePinCode'];
    addresseeCity = db['AddresseeCity'];
    addresseeState = db['AddresseeState'];
    addresseeMobileNumber = db['AddresseePhone'];
    addresseeEmail = db['AddresseeEmail'];
    date = db['InvoiceDate'];
    time = db['InvoiceTime'];
    status = db['Status'];
  }
}
