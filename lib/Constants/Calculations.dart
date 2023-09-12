import 'dart:math';

import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/DatabaseModel/PostOfficeModel.dart';
import 'package:darpan_mine/Mails/Booking/RegisterLetter/Screens/RegisterLetterBookingScreen1.dart';
import 'package:vector_math/vector_math.dart';

bool senderExpansion = false;
bool addresseeExpansion = false;

var weightAmt = 0.0;
var ppAmt = 0.0;
var ackAmt = 0.0;
var insAmt = 0.0;
var vppAmt = 0.0;
var podAmt = 0.0;
var registrationFee = 0.0;
var doorDeliveryFee = 0.0;
var airMailAmt = 0.0;
var emoValueAmt = 0;
var commissionAmt = 0;
var serviceTax = 0.0;
String distancecode = "L";
String weightcode = "W1";
String spdistance = "0";

class Fees {
  getRegistrationFees(String type) async {
    registrationFee = 0;

    final fee = await Vaservice()
        .select()
        .startBlock
        .Productcode
        .contains(type)
        .and
        .VASdescription
        .contains('Registration Fee')
        .endBlock
        .toList();
    print("Fee is $fee");
    registrationFee = fee[0].VASPrice!;
    return fee[0].VASPrice;
  }

  getAcknowledgementFee(String type) async {
    ackAmt = 0;
    final fee = await Vaservice()
        .select()
        .startBlock
        .Productcode
        .contains(type)
        .and
        .VASdescription
        .contains('Acknowledgement Fee')
        .endBlock
        .toList();
    ackAmt = fee[0].VASPrice!;
  }

  getProofOfDeliveryFee(String type) async {
    podAmt = 0;
    final fee = await Vaservice()
        .select()
        .startBlock
        .Productcode
        .contains(type)
        .and
        .VASdescription
        .contains('Proof Of Delivery')
        .endBlock
        .toList();
    podAmt = fee[0].VASPrice!;
  }

  getDoorDeliveryFee(int weight, String type) async {
    doorDeliveryFee = 0;
    if (weight < 5000) {
      doorDeliveryFee = 0;
    } else {
      final fee = await Vaservice()
          .select()
          .startBlock
          .Productcode
          .contains(type)
          .and
          .VASdescription
          .contains('Door Delivery Charges')
          .endBlock
          .toList();
      doorDeliveryFee = fee[0].VASPrice!;
    }
  }

  getValidations(String type) async {
    maxWeight = 0;
    final mw = await WeightValidation()
        .select(columnsToSelect: ['WeightMax'])
        .Product
        .contains(type)
        .toList();
    maxWeight = mw[0].WeightMax;
    return mw[0].WeightMax!.toInt();
  }

  getWeightAmount(int weight, String type) async {
    print('inside Weight Amount Function..!');
    weightAmt = 0.0;
    final weightValue = await Price()
        .select(columnsToSelect: ['Conditionrate'])
        .Productcode
        .equals(type)
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

    print('Weight Amount is = ' + weightAmt.toString());
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
    vppAmt = 0;
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

  getAirmailService(int weight) {
    airMailAmt = 0;
    if (weight < 50) {
      airMailAmt = 2.0;
    } else {
      airMailAmt = ((weight / 50) - 1) + 2;
    }
  }

  getCommission(int amount) async {
    commissionAmt = 0;
    final commission = amount ~/ 20;
    commissionAmt = commission.toInt();
    return commissionAmt;
  }

  getSpeedFee(String senderPinCode, String receiverPinCode, int weight,double podAmount) async {
    final ofcMaster = await OFCMASTERDATA().select().toList();
    senderPinCode = ofcMaster[0].Pincode.toString();

    print("Inside Speed Post Tariff Calculation function");
    print(senderPinCode + " - " + receiverPinCode + " - " + weight.toString());
    var distance;
    var insValue = 0;
    insAmt = 0.0;
    serviceTax = 0.0;
    registrationFee = 0.0;
    double earthRadian = 6371.00;
    int adjustmentFactor = 1;
    double? sourceLatitude;
    double? sourceLongitude;
    double? destinationLatitude;
    double? destinationLongitude;

    final localPin = await Local_pin()
        .select(columnsToSelect: ["Var1"])
        .SourcePinCode
        .contains(senderPinCode)
        .and
        .LocalPinCode
        .contains(receiverPinCode)
        .toList();
    int len = localPin.length;

    final sourceCoOrdinateLocation = await OfficeMasterPinCode()
        .select()
        .Pincode
        .contains(senderPinCode)
        .and
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
        .toList();

    print("Source Office Details in Calculation..!");
    print(sourceCoOrdinateLocation);

    final destinationCoOrdinateLocation = await OfficeMasterPinCode()
        .select()
        .Pincode
        .contains(receiverPinCode)
        .and
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
        .toList();

    if(sourceCoOrdinateLocation.length>0) {
      sourceLatitude = double.tryParse(
          sourceCoOrdinateLocation[0].Latitude.toString());
      sourceLongitude = double.tryParse(
          sourceCoOrdinateLocation[0].Longitude.toString());
    }
    else{
      sourceLatitude=0;
      sourceLongitude=0;
    }
    if(destinationCoOrdinateLocation.length>0) {
      destinationLatitude = double.tryParse(
          destinationCoOrdinateLocation[0].Latitude.toString());
      destinationLongitude = double.tryParse(
          destinationCoOrdinateLocation[0].Longitude.toString());
    }
    else
      {
        destinationLatitude=0;
        destinationLongitude=0;
      }
    // double sourceLongitude =
    //     double.parse(sourceCoOrdinateLocation[0].Longitude.toString());
    // double destinationLatitude =
    //     double.parse(destinationCoOrdinateLocation[0].Latitude.toString());
    // double destinationLongitude =
    //     double.parse(destinationCoOrdinateLocation[0].Longitude.toString());

    double calc_1 = sin(radians(destinationLatitude! - sourceLatitude!) / 2) *
            sin(radians(destinationLatitude - sourceLatitude) / 2) +
        cos(radians(sourceLatitude)) *
            cos(radians(destinationLatitude)) *
            sin(radians(destinationLongitude! - sourceLongitude!) / 2) *
            sin(radians(destinationLongitude - sourceLongitude) / 2);
    double calc_2 = 2 * atan2(sqrt(calc_1), sqrt(1 - calc_1));
    distance = (earthRadian * calc_2 * adjustmentFactor);

    print(sourceLatitude.toString());
    print(sourceLongitude.toString());
    print(destinationLatitude.toString());
    print(destinationLongitude.toString());

    print(calc_1.toString());
    print(calc_2.toString());
    print("Distance is ");
    print(distance.toString());

    //when sender and received pincode is same
    if ((senderPinCode == receiverPinCode) || len != 0) {
      print("if-1");
      final baseTariff = await Base_Tariff_SP()
          .select()
          .startBlock
          .WeightDescriptionStart
          .lessThanOrEquals(weight)
          .and
          .WeightDescriptionEnd
          .greaterThanOrEquals(weight)
          .and
          .Distance
          .contains('L')
          .endBlock
          .toList();

      serviceTax =
          ((
              (insValue + double.parse(baseTariff[0].Conditionrate.toString()) + podAmount) *
                  double.parse(baseTariff[0].ServiceTax.toString())
          ) /
              200).roundToDouble()*2;
      registrationFee = double.parse(baseTariff[0].Conditionrate.toString());
      distancecode = baseTariff[0].Distance.toString();
      weightcode = baseTariff[0].Weight.toString();
      spdistance = distance.toString();
    }

    //when distance is less than 2000 km.
    else if ((distance!.round()) < 2000) {
      print("if-2");
      print(weight);
      final baseTariff = await Base_Tariff_SP()
          .select()
          .startBlock
          .WeightDescriptionStart
          .lessThanOrEquals(weight)
          .and
          .WeightDescriptionEnd
          .greaterThanOrEquals(weight)
          .and
          .DistanceDescriptionStart
          .lessThanOrEquals(distance)
          .and
          .DistanceDescriptionEnd
          .greaterThanOrEquals(distance)
          .endBlock
          .toList();

      print(baseTariff.length);

      // serviceTax =
      //     ((insValue + double.parse(baseTariff[0].Conditionrate.toString())+ podAmount) *
      //             double.parse(baseTariff[0].ServiceTax.toString())) /
      //         100;
      serviceTax =
          ((
              (insValue + double.parse(baseTariff[0].Conditionrate.toString()) + podAmount) *
                  double.parse(baseTariff[0].ServiceTax.toString())
          ) /
              200).roundToDouble()*2;

      print(distance.toString());
      print(baseTariff[0].Distance.toString());
      print(baseTariff[0].Weight.toString());
      print('Registration Fee-');
      print(baseTariff[0].Conditionrate.toString());

      registrationFee = double.parse(baseTariff[0].Conditionrate.toString());

      distancecode = baseTariff[0].Distance.toString();
      weightcode = baseTariff[0].Weight.toString();
      spdistance = distance.toString();
    }
    //when distance is more than 2000km.
    else {
      print("if-3");
      final baseTariff = await Base_Tariff_SP()
          .select()
          .startBlock
          .WeightDescriptionStart
          .lessThanOrEquals(weight)
          .and
          .WeightDescriptionEnd
          .greaterThanOrEquals(weight)
          .and
          .DistanceDescriptionStart
          .lessThanOrEquals(distance)
          .and
          .DistanceDescriptionEnd
          .equals("Above")
          .endBlock
          .toList();

      // serviceTax =
      //     ((insValue + double.parse(baseTariff[0].Conditionrate.toString())+ podAmount) *
      //             double.parse(baseTariff[0].ServiceTax.toString())) /
      //         100;
      serviceTax =
          ((
              (insValue + double.parse(baseTariff[0].Conditionrate.toString()) + podAmount) *
                  double.parse(baseTariff[0].ServiceTax.toString())
          ) /
              200).roundToDouble()*2;

      registrationFee = double.parse(baseTariff[0].Conditionrate.toString());
      distancecode = baseTariff[0].Distance.toString();
      weightcode = baseTariff[0].Weight.toString();
      spdistance = distance.toString();

      print("Registration fee is $registrationFee");
    }
    print("END SPEED TARIFF CALCULATION");
    print(spdistance);
    print(distancecode);
    print(weightcode);
  }
}
