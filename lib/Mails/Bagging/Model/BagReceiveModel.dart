class BagModel {
  final String bagNumber;
  final String fromOffice;
  final String toOffice;
  final String tDate;
  final String tTime;
  final String userID;
  final String bagStatus;
  final List<BagArticles> bagArticles;
  final List<BagStamps> bagStamps;
  final List<String> bagDocuments;

  BagModel(
      {required this.bagNumber,
      required this.fromOffice,
      required this.toOffice,
      required this.tDate,
      required this.tTime,
      required this.userID,
      required this.bagStatus,
      required this.bagArticles,
      required this.bagStamps,
      required this.bagDocuments});

  factory BagModel.fromJson(Map<String, dynamic> json) {
    return BagModel(
        bagNumber: json['bagNumber'],
        fromOffice: json['fromOffice'],
        toOffice: json['toOffice'],
        tDate: json['tDate'],
        tTime: json['tTime'],
        userID: json['userID'],
        bagStatus: json['bagStatus'],
        bagArticles: parseBagArticles(json),
        bagStamps: parseBagStamps(json),
        bagDocuments: parsedDocuments(json['bagDocuments']));
  }

  static List<BagArticles> parseBagArticles(bagArticlesJson) {
    var list = bagArticlesJson['bagArticles'] as List;
    List<BagArticles> articlesList =
        list.map((e) => BagArticles.fromJson(e)).toList();
    return articlesList;
  }

  static List<BagStamps> parseBagStamps(bagStampsJson) {
    var list = bagStampsJson['bagStamps'] as List;
    List<BagStamps> stampsList =
        list.map((e) => BagStamps.fromJson(e)).toList();
    return stampsList;
  }

  static List<String> parsedDocuments(documentsJson) {
    List<String> documentsList = List<String>.from(documentsJson);
    return documentsList;
  }
}

class BagArticles {
  final String type;
  final String article;

  BagArticles({required this.type, required this.article});

  factory BagArticles.fromJson(Map<String, dynamic> parsedJson) {
    return BagArticles(
        type: parsedJson['type'], article: parsedJson['article']);
  }
}

class BagStamps {
  final String type;
  final String count;

  BagStamps({required this.type, required this.count});

  factory BagStamps.fromJson(Map<String, dynamic> parsedJson) {
    return BagStamps(type: parsedJson['type'], count: parsedJson['count']);
  }
}
