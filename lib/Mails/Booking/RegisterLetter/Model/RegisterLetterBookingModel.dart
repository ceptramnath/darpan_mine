class RegisterLetterModel {
  String? articleNumber;
  String? weight;
  String? weightAmount;
  int? prepaidAmount;
  int? acknowledgementAmount;
  String? insuranceAmount;
  String? vppAmount;
  double? registrationFee;
  String? amountToBeCollected;
  String? senderName;
  String? senderAddress;
  int? senderPinCode;
  String? senderCity;
  String? senderState;
  String? senderMobileNumber;
  String? senderEmail;
  String? addresseeName;
  String? addresseeAddress;
  int? addresseePinCode;
  String? addresseeCity;
  String? addresseeState;
  String? addresseeMobileNumber;
  String? addresseeEmail;
  String? date;

  RegisterLetterModel(
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
      this.date);

  RegisterLetterModel.fromDB(Map<String, dynamic> db) {
    articleNumber = db['ArticleNumber'];
    weight = db['Weight'];
    weightAmount = db['WeightAmount'];
    prepaidAmount = db['PrepaidAmount'];
    acknowledgementAmount = db['AcknowledgementService'];
    insuranceAmount = db['InsuranceService'];
    vppAmount = db['ValuePayableService'];
    registrationFee = db['RegistrationFee'];
    amountToBeCollected = db['AmountToBeCollected'];
    senderName = db['SenderName'];
    senderAddress = db['SenderAddress'];
    senderPinCode = db['SenderPincode'];
    senderCity = db['SenderCity'];
    senderState = db['SenderState'];
    senderMobileNumber = db['SenderMobileNumber'];
    senderEmail = db['SenderEmail'];
    addresseeName = db['AddresseeName'];
    addresseeAddress = db['AddresseeAddress'];
    addresseePinCode = db['AddresseePincode'];
    addresseeCity = db['AddresseeCity'];
    addresseeState = db['AddresseeState'];
    addresseeMobileNumber = db['AddresseeMobileNumber'];
    addresseeEmail = db['AddresseeEmail'];
    date = db['RemarkDate'];
  }
}
