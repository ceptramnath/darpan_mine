
import 'package:newenc/newenc.dart';

// decryptHeader(String val) async {
//   var sdk = val.toString().replaceAll("]", "");
//   print(sdk.substring(1, sdk.length - 2));
//   var decryptSignature = sdk.substring(1, sdk.length - 2);
//   return decryptSignature;
// }

// Future<String> decryption1(String signature, String res) async {
//   String test = await Encdec.decrypt(signature, res);
//   print("Signature verification in decrypt");
//   print(test);
//   return test;
// }
Future<String> decryption1(String signature, String res) async {
  String test = await Newenc.verifyString(signature, res);
  print("Signature verification in decrypt");
  print(test);
  return test;
}
