class AllTransactionsModel {
  String? id;
  String? type;
  String? description;
  String? date;
  String? time;
  double? amount;
  String? valuation;

  AllTransactionsModel(this.id, this.type, this.description, this.date,
      this.time, this.amount, this.valuation);

  AllTransactionsModel.fromDB(Map<String, dynamic> db) {
    id = db['tranid'];
    type = db['tranType'];
    description = db['tranDescription'];
    date = db['tranDate'];
    time = db['tranTime'];
    amount = db['tranAmount'];
    valuation = db['valuation'];
  }
}
