class BagOpenModel {
  late String bagNumber;
  late String bagWeight;
  late String receivedDate;
  late String receivedTime;
  late String status;

  BagOpenModel(this.bagNumber, this.bagWeight, this.receivedDate,
      this.receivedTime, this.status);

  BagOpenModel.fromDB(Map<String, dynamic> db) {
    bagNumber = db['BagNumber'];
    bagWeight = db['Weight'];
    receivedDate = db['ReceivedDate'];
    receivedTime = db['ReceivedTime'];
    status = db['Status'];
  }
}

class BagArticlesModel {
  String? articleNumber;
  bool? isReceived;

  BagArticlesModel({required this.articleNumber, required this.isReceived});
}

class InventoryModel {
  String? itemName;
  String? itemPrice;
  String? itemQuantity;

  InventoryModel(this.itemName, this.itemPrice, this.itemQuantity);

  InventoryModel.fromDB(Map<String, dynamic> db) {
    itemName = db['ItemName'];
    itemPrice = db['ItemDenomination'];
    itemQuantity = db['ItemBalance'];
  }
}

//added below model by Rohit to insert/update Articles received in Bag

class ArticlesinBag {
  String? articleNumber;
  String? articleType;
  String? amount;
  String? commission;

  ArticlesinBag(
      {required this.articleNumber,
      required this.articleType,
      required this.amount,
      required this.commission});
}
