import 'package:darpan_mine/Constants/Calculations.dart';
import 'package:darpan_mine/DatabaseModel/PostOfficeModel.dart';
import 'package:darpan_mine/Mails/Booking/RegisterLetter/Screens/RegisterLetterBookingScreen1.dart';

bool senderExpansion = false;
bool addresseeExpansion = false;

class Fees {
  //Register Letter Calculations
  /*-------------------------------------------------------*/
  getRegistrationFees(String type) async {
    final price = await Vaservice()
        .select()
        .startBlock
        .Productcode
        .contains(type)
        .and
        .VASdescription
        .contains('Registration Fee')
        .endBlock
        .toList();
    print("Length");
    print(price.length);
    print(price[0].VASPrice);
    return price[0].VASPrice;
  }

  getValidations() async {
    final mw = await WeightValidation()
        .select(columnsToSelect: ['WeightMax'])
        .Product
        .contains('LETTER')
        .toList();
    maxWeight = mw[0].WeightMax;
  }

  getWeightAmount(int weight) async {
    weightAmt = 0.0;
    final weightValue = await Price()
        .select(columnsToSelect: ['Conditionrate'])
        .Productcode
        .equals('LETTER')
        .and
        .startBlock
        .WeightDescriptionStart
        .lessThanOrEquals(weight)
        .and
        .WeightDescriptionEnd
        .greaterThanOrEquals(weight)
        .endBlock
        .toList();
    weightAmt = weightValue[0].Conditionrate!;
  }

  getInsuranceAmount(int amount) async {
    insAmt = 0.0;
    final insValue = await Insurance()
        .select(columnsToSelect: ['Commission'])
        .MinAmount
        .lessThanOrEquals(amount)
        .and
        .MaxAmount
        .greaterThanOrEquals(amount)
        .toList();
    insAmt = insValue[0].Commission!;
  }

  getVPPAmount(int amount) async {
    final vppValue = await Vpp()
        .select(columnsToSelect: ['Commission'])
        .MinAmount
        .lessThanOrEquals(amount)
        .and
        .MaxAmount
        .greaterThanOrEquals(amount)
        .toList();
    vppAmt = vppValue[0].Commission!;
  }

  /*-------------------------------------------------------*/

  //Mails.Booking.EMO Calculations
  /*-------------------------------------------------------*/
  getCommission(int amount) async {
    commissionAmt = 0;
    final commission = amount ~/ 20;
    commissionAmt = commission.toInt();
    return commissionAmt;
  }
/*-------------------------------------------------------*/

}
