cbsErrors(String actype) {
  String response = "";
  switch (actype) {
    case 'F':
      response = "Account is Frozen";
      break;
    case 'C':
      response = "Account is Closed";
      break;
    case 'D':
      response = "Account is Debit Frozen";
      break;
    case 'R':
      response = "Account is Credit Frozen";
      break;
    case 'M':
      response = "Account is Dormant";
      break;
    case 'I':
      response = "Account is Inactive";
      break;
  }
  return response;
}
