class TransactionModel {
  int? id;
  String? description;
  double? amount;
  String? date;
  String? time;
  String? type;

  TransactionModel(
      this.id, this.description, this.amount, this.date, this.time, this.type);

  TransactionModel.fromDB(Map<String, dynamic> db) {
    id = db['Transaction_ID'];
    description = db['Transaction_Description'];
    amount = db['Transaction_Amount'];
    date = db['Transaction_Date'];
    time = db['Transaction_Time'];
    type = db['Transaction_Type'];
  }
}
