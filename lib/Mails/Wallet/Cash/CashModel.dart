class CashModel {
  String? id;
  String? date;
  String? time;
  double? amount;
  String? description;
  String? type;

  CashModel(
      this.id, this.date, this.time, this.amount, this.description, this.type);

  CashModel.fromDB(Map<String, dynamic> db) {
    id = db['Cash_ID'];
    date = db['Cash_Date'];
    time = db['Cash_Time'];
    amount = db['Cash_Amount'];
    description = db['Cash_Description'];
    type = db['Cash_Type'];
  }
}
