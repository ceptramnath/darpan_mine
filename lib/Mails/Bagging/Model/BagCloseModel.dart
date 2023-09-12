class BagCloseModel {
  late String bagNumber;
  late String bagWeight;
  late String receivedDate;
  late String receivedTime;
  late String openedDate;
  late String openedTime;

  BagCloseModel(this.bagNumber, this.bagWeight, this.receivedDate,
      this.receivedTime, this.openedDate, this.openedTime);

  BagCloseModel.fromDB(Map<String, dynamic> db) {
    bagNumber = db['BagNumber'];
    bagWeight = db['Weight'];
    receivedDate = db['ReceivedDate'];
    receivedTime = db['ReceivedTime'];
    openedDate = db['OpenedDate'];
    openedTime = db['OpenedTime'];
  }


}


class ArticleCloseModel{

  late String ArticleNumber;
  late String ArticleType;
  late String Remark;
  late bool Scanned;

  ArticleCloseModel(this.ArticleNumber,this.ArticleType,this.Remark,this.Scanned);

}
