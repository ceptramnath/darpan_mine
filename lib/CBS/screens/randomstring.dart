import 'dart:math';

import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';

// Define a reusable function
class GenerateRandomString {
  String newaccrefnum(String circlecode) {
    var number = "";
    var randomnumber = Random();
    //chnage i < 15 on your digits need
    for (var i = 0; i < 5; i++) {
      number = number + randomnumber.nextInt(9).toString();
    }
    String ref = "F" +
        DateTimeDetails().cbsRefdatetime() +
        number.toString() +
        "$circlecode";
    // String ref="F"+DateTimeDetails().cbsRefdatetime()+"70164"+"$circlecode";
    // String ref="F"+DateTimeDetails().cbsRefdatetime()+"31417"+"$circlecode";
    return ref;
  }

  String randomString() {
    final _random = Random();
    const _availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrTtUuVvWwXxYyZz1234567890';
    final rstg = List.generate(12,
            (index) => _availableChars[_random.nextInt(_availableChars.length)])
        .join();
    return rstg;
  }

  random12Number() {
    var number = "";
    var randomnumber = Random();
    //chnage i < 15 on your digits need
    for (var i = 0; i < 12; i++) {
      number = number + randomnumber.nextInt(9).toString();
    }
    print(number);
    return number;
    // var rng = Random();
    // var rngNum = List.generate(1, (_) => rng.nextInt(1000000000000));
    // return rngNum;
    // new Random().nextInt(9999999)
    // Random random = Random();
    // int randomNumber = random.nextInt(1000000000000);
    // return randomNumber;
  }

  randomNumber() {
    // var rng = Random();
    // var rngNum = List.generate(12, (_) => rng.nextInt(100));
    // return rngNum;
    Random random = Random();
    int randomNumber = random.nextInt(10000000);
    return randomNumber;
  }
}
