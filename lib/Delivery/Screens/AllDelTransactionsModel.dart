class AllDelTransactionsModel {
  String? articleNumber;
  String? date;
  String? time;
  int? amountToBeCollected;
  String? type;

  AllDelTransactionsModel(this.articleNumber, this.date, this.time,
      this.amountToBeCollected, this.type);

  AllDelTransactionsModel.fromDB(Map<String, dynamic> db) {
    articleNumber = db['ART_NUMBER'];
    date = db['DEL_DATE'];
    time = db['DELIVERY_TIME'];
    amountToBeCollected = db['MONEY_COLLECTED'];
    type = db['MATNR'];
  }
}
