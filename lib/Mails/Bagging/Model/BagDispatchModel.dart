class BagDispatchModel {
  late String bagNumber;
  late String bagWeight;
  late String receivedDate;
  late String receivedTime;
  late String openedDate;
  late String openedTime;
  late String closedDate;
  late String closedTime;

  BagDispatchModel(
      this.bagNumber,
      this.bagWeight,
      this.receivedDate,
      this.receivedTime,
      this.openedDate,
      this.openedTime,
      this.closedDate,
      this.closedTime);

  BagDispatchModel.fromDB(Map<String, dynamic> db) {
    bagNumber = db['BagNumber'];
    bagWeight = db['Weight'];
    receivedDate = db['ReceivedDate'];
    receivedTime = db['ReceivedTime'];
    openedDate = db['OpenedDate'];
    openedTime = db['OpenedTime'];
    closedDate = db['ClosedDate'];
    closedTime = db['ClosedTime'];
  }
}
