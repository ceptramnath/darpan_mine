import 'dart:async';

import 'package:darpan_mine/DatabaseModel/PostOfficeModel.dart';

class FetchPin {
  static Future<List<Map<String, String>>> getSuggestions(String query) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    List<OfficeMasterPinCode> pin = [];
    if (query.length >= 3) {
      pin = await OfficeMasterPinCode()
          .select()
          // .EndDate
          // .greaterThan(DateTime(
          //     DateTime.now().year, DateTime.now().month, DateTime.now().day))
          // .and
          .Delivery
          .not
          .equals("Non-Delivery")
          .and
          .startBlock
          .OfficeType
          .equals('HO')
          .or
          .OfficeType
          .equals('PO')
          .endBlock
          .and
          .startBlock
          .Pincode
          .contains(query.toString())
          .or
          .OfficeName
          .contains(query.toString())
          .endBlock
          .toList();
      pin.sort(
          (a, b) => a.Priority.toString().compareTo(b.Priority.toString()));
    }
    return List.generate(pin.length, (index) {
      print('Selected pincode is ${pin[index].OfficeType.toString()}');
      return {
        'pinCode': pin[index].Pincode.toString(),
        'officeName': pin[index].OfficeName.toString(),
        'city': pin[index].ReceiverCityDistrict.toString(),
        'state': pin[index].State.toString()
      };
    });
  }
}
