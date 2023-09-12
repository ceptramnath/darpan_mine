class fetchacc {
  Future<List> split126accenquiry(String main) async {
    List rec = main.toString().split("|");

    return rec;
  }

  Future<List?> split125(String main) async {
    String cifid = main.toString().substring(0, 32);
    String cname = main.toString().substring(32, 112);
    String accname = main.toString().substring(112, 192);
    String acopendate = main.toString().substring(192, 200);
    String schcode = main.toString().substring(200, 205);
    String actype = main.toString().substring(205, 208);
    String acstatus = main.toString().substring(208, 209);
    String opcode = main.toString().substring(209, 214);
    String jh1 = main.toString().substring(214, 294);
    String jh2 = main.toString().substring(294, 374);
    String jh3 = main.toString().substring(374, 454);
    String glcode = main.toString().substring(454, 459);
    String solid = main.toString().substring(459, 467);
    String drawing = main.toString().substring(467, 484);
    String lien = main.toString().substring(484, 501);
    List rec = [
      cifid.replaceAll(' ', ''),
      cname,
      accname,
      acopendate,
      schcode,
      actype,
      acstatus,
      opcode,
      jh1,
      jh2,
      jh3,
      glcode,
      solid,
      drawing,
      lien
    ];
    return rec;
  }

  Future<List?> split126(String depositmain) async {
    String tranID = depositmain.toString().substring(0, 8);
    String tranDate = depositmain.toString().split("_") as String;
    String bankId = depositmain.toString().split("_") as String;
    String lastTranDate = depositmain.toString().split("_") as String;

    List rec = [tranID, tranDate, bankId, lastTranDate];
    return rec;
  }

  Future<List?> split126GEN(String depositmain) async {
    String adharnummainhldr = depositmain.toString().substring(0, 12);
    String CSIBOid = depositmain.toString().split("|") as String;
    String lastTRNdate = depositmain.toString().split("|") as String;
    String modeofoperation = depositmain.toString().split("|") as String;
    String jointCIF1ID = depositmain.toString().split("|") as String;
    String jointCIF1aadhar = depositmain.toString().split("|") as String;
    String jointCIF2ID = depositmain.toString().split("|") as String;
    String jointCIF2aadhar = depositmain.toString().split("|") as String;
    String jointCIF3ID = depositmain.toString().split("|") as String;
    String jointCIF3aadhar = depositmain.toString().split("|") as String;
    String schmAllowed = depositmain.toString().split("|") as String;
    String solBOdate = depositmain.toString().split("|") as String;
    List rec = [
      adharnummainhldr,
      CSIBOid,
      lastTRNdate,
      modeofoperation,
      jointCIF1ID,
      jointCIF1aadhar,
      jointCIF2ID,
      jointCIF2aadhar,
      jointCIF3ID,
      jointCIF3aadhar,
      schmAllowed,
      solBOdate
    ];
    return rec;
  }

  Future<List?> split126RD(String depositmain) async {
    var splitParams = depositmain.toString().split("|");
    String adharnummainhldr = splitParams[0];
    String CSIBOid = splitParams[1];
    String lastTRNdate = splitParams[2];
    String InstallmentAmt = splitParams[3];
    String amtPaid = splitParams[4];
    String totDepallowed = splitParams[5];
    String depReqcus = splitParams[6];
    String rebateamt = splitParams[7];
    String lateFee = splitParams[8];
    String finalTranAmt = splitParams[9];
    String LateInstallmentsBeingPaidCount = splitParams[10];
    String agentLinkedRD = splitParams[11];
    String lastTranDate = splitParams[12];
    String jointCIF1ID = splitParams[13];
    String jointCIF1aadhar = splitParams[14];
    String jointCIF2ID = splitParams[15];
    String jointCIF2aadhar = splitParams[16];
    String jointCIF3ID = splitParams[17];
    String jointCIF3aadhar = splitParams[18];
    String schmAllowed = splitParams[22];
    String solBOdate = splitParams[23];

    List rec = [
      adharnummainhldr,
      CSIBOid,
      lastTRNdate,
      InstallmentAmt,
      amtPaid,
      totDepallowed,
      depReqcus,
      rebateamt,
      lateFee,
      finalTranAmt,
      LateInstallmentsBeingPaidCount,
      agentLinkedRD,
      lastTranDate,
      jointCIF1ID,
      jointCIF1aadhar,
      jointCIF2ID,
      jointCIF2aadhar,
      jointCIF3ID,
      jointCIF3aadhar,
      schmAllowed,
      solBOdate
    ];
    return rec;
  }

  Future<List?> split126RDGEN(String depositmain) async {
    var splitParams = depositmain.toString().split("|");
    String adharnummainhldr = splitParams[0];
    String CSIBOid = splitParams[1];
    String lastTRNdate = splitParams[2];
    String InstallmentAmt = splitParams[3];
    String amtPaid = splitParams[4];
    String totDepallowed = splitParams[5];
    String depReqcus = splitParams[6];
    List rebateamt = splitParams[7].toString().split(".");
    List defaultFee = splitParams[8].toString().split(".");
    List finalTranAmt = splitParams[9].toString().split(".");
    List LateInstallmentsBeingPaidCount = splitParams[10].toString().split(".");
    String agentLinkedRD = splitParams[11];
    String c91 = splitParams[7];
    String d91 = splitParams[8];
    // String modeOfOperation=splitParams[12] ;
    // String jointCIF1ID=splitParams[13] ;
    // String jointCIF1aadhar=splitParams[14] ;
    // String jointCIF2ID=splitParams[15] ;
    // String jointCIF2aadhar=splitParams[16] ;
    // String jointCIF3ID=splitParams[17] ;
    // String jointCIF3aadhar=splitParams[18] ;
    // String schmAllowed=splitParams[22] ;
    // String solBOdate=splitParams[23] ;

    List rec = [
      adharnummainhldr,
      CSIBOid,
      lastTRNdate,
      InstallmentAmt,
      amtPaid,
      totDepallowed,
      depReqcus,
      rebateamt[0],
      defaultFee[0],
      finalTranAmt[0],
      LateInstallmentsBeingPaidCount[0],
      agentLinkedRD,
      c91,
      d91
    ];
    return rec;
  }

  Future<List?> split48(String main) async {
    String ledgerbalance = main.toString().substring(1, 17);
    String availbal = main.toString().substring(18, 34);
    String floatbal = main.toString().substring(35, 51);
    String ffdbal = main.toString().substring(52, 68);
    String userdefbal = main.toString().substring(69, 85);
    String balcurrcode = main.toString().substring(85, 88);
    String fallbacktime = main.toString().substring(88, 102);

    List bal = [
      ledgerbalance,
      availbal,
      floatbal,
      ffdbal,
      userdefbal,
      balcurrcode,
      fallbacktime
    ];
    return bal;
  }

  Future<List?> splitministatement(String main) async {
    print(main.length);
    int mainlength = (main.length ~/ 87);
    print(mainlength);
    print("Inside splitministatement");
    List? response = [];
    List? tempresponse = [];
    for (int i = 0, j = 0; i < mainlength * 87; i = i + 87, j++) {
      print(i);
      tempresponse.add(main.toString().substring(i + 0, i + 87));
      print(tempresponse[j]);
    }
    print("Tempresponse length: ${tempresponse.length}");
    for (int i = 0; i < tempresponse.length; i++) {
      response.add(tempresponse[i].toString().substring(0, 8));
      response.add(tempresponse[i].toString().substring(8, 24));
      response.add(tempresponse[i].toString().substring(24, 29));
      response.add(tempresponse[i].toString().substring(29, 69));
      response.add(tempresponse[i].toString().substring(69, 70));
      response.add(tempresponse[i].toString().substring(70, 87));
      print(response[0]);
    }
    return response;
  }

  Future<List?> splitBODetails(String main) async {
    var splitParams = main.toString().split("|");
    String boid = splitParams[0];
    String solid = splitParams[1];
    String soldesc = splitParams[2];
    String cashscrollmax = splitParams[3];
    String bocashnewacc = splitParams[4];
    List fest = [boid, solid, soldesc, cashscrollmax, bocashnewacc];
    return fest;
  }

  Future<List?> splitNewAccount(List main) async {
    var splitparams;
    List? final1 = [];
    for (int i = 0; i < main.length; i++) {
      splitparams = main[i].split("|");
      final1.add(splitparams);
    }
    return final1;
    // List fest=[boid,solid,soldesc,cashscrollmax,bocashnewacc];
    // return fest;
  }
}

fetchacc fac = new fetchacc();
