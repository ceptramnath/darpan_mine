import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';

class FetchArticles {
  static Future<List<Map<String, String>>> getArticles(String query) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    List article = [];
    if (query.length > 3) {
      List letter = await LetterBooking()
          .select()
          .ArticleNumber
          .contains(query.toString()).and.FileCreated.not.equals("Y")
          .toMapList();
      if (letter.isNotEmpty) {
        article.add(letter);
      }

      List speed = await SpeedBooking()
          .select()
          .ArticleNumber
          .contains(query.toString()).and.FileCreated.not.equals("Y")
          .toMapList();
      if (speed.isNotEmpty) {
        article.add(speed);
      }

      List parcel = await ParcelBooking()
          .select()
          .ArticleNumber
          .contains(query.toString()).and.FileCreated.not.equals("Y")
          .toMapList();
      if (parcel.isNotEmpty) {
        article.add(parcel);
      }
    }
    return List.generate(article.length, (index) {
      return {'article': article[0][0]['ArticleNumber'].toString()};
    });
  }
}
