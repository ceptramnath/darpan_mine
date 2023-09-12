import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';

class BillerDetails {
  static Future<List<Map<String, String>>> getBillerData(String query) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    List<BillerData> billderData = [];
    if (query.isNotEmpty) {
      billderData = await BillerData()
          .select()
          .startBlock
          .BillerId
          .contains(query.toString())
          .or
          .BillerName
          .contains(query.toString())
          .endBlock
          .toList();
    }
    return List.generate(billderData.length, (index) {
      return {
        'id': billderData[index].BillerId.toString(),
        'name': billderData[index].BillerName.toString()
      };
    });
  }
}
