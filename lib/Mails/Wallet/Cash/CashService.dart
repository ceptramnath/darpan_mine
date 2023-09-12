import 'package:darpan_mine/DatabaseModel/transtable.dart';

class CashService {
  var balance =0.0;

  cashBalance() async {
    var allCash = await CashTable().select().toList();
    for (int i = 0; i < allCash.length; i++) {
      if (allCash[i].Cash_Type == 'Add') {
        balance += allCash[i]
            .Cash_Amount!; //If cash type is add -> adding amount to balance
      } else if (allCash[i].Cash_Type == 'Minus') {
        balance -= allCash[i]
            .Cash_Amount!; //If cash type is minus -> subtracting amount to balance
      }
    }
    return balance;
  }
}
