Future<String?> policyCodes(String ptype) async {
  switch (ptype) {
    case "Suraksha":
      return "001";
    case "Suvidha":
      return "100";
    case "RuralChildrenPolicy":
      return "950";
    case "Santosh":
      return "200";
    case "Sumangal":
      return "300";
    case "YugalSuraksha":
      return "400";
    case "Children Policy":
      return "450";
    case "GramSuraksha":
      return "500";
    case "GramSuvidha":
      return "600";
    case "GramSantosh":
      return "700";
    case "GramSumangal":
      return "800";
    case "GramPriya ":
      return "900";
  }
}

Future<String?> policyTypes(String ptype) async {
  switch (ptype) {
    case "001":
      return "Suraksha";
    case "100":
      return "Suvidha";
    case "950":
      return "RuralChildrenPolicy";
    case "200":
      return "Santosh";
    case "300":
      return "Sumangal";
    case "400":
      return "YugalSuraksha";
    case "450":
      return "Children Policy";
    case "500":
      return "GramSuraksha";
    case "600":
      return "GramSuvidha";
    case "700":
      return "GramSantosh";
    case "800":
      return "GramSumangal";
    case "900":
      return "GramPriya";
  }
}
