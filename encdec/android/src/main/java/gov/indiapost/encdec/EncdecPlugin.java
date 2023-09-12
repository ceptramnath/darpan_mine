package gov.indiapost.encdec;

import androidx.annotation.NonNull;

import org.bouncycastle.crypto.CipherParameters;
import org.bouncycastle.crypto.digests.Blake2bDigest;
import org.bouncycastle.crypto.params.Ed25519PrivateKeyParameters;
import org.bouncycastle.crypto.params.Ed25519PublicKeyParameters;
import org.bouncycastle.crypto.signers.Ed25519Signer;
import org.bouncycastle.util.encoders.Hex;

import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** EncdecPlugin */
public class EncdecPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  public SigningUtility signingUtility;
  SigningModel signing = new SigningModel();
  String sign = null;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "encdec");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }

    else if (call.method.equals("encrypt")) {
System.out.println("Signing at functioncall: "+signing);
      String s=encrypt(call.argument("a"));
      result.success(s);
    }

    else if (call.method.equals("decrypt")) {

      String s=decrypt(call.argument("a"),call.argument("b"));
      result.success(s);
    }

    else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  public String encrypt(String req){
try {
  final long currentTime = System.currentTimeMillis() / 1000L;
  final int headerValidity = 3600;
  final String blakeHash = this.generateBlakeHash(req);
  final String signingString = "(created): " + currentTime + "\n(expires): " + (currentTime + headerValidity) + "\ndigest: BLAKE-512=" + blakeHash + "";

  System.out.println(signing);
  System.out.println(signingString);
//  final String signature =signingUtility.generateSignature(signingString, signing);
//    final String kid = "beckn.org-|1" + "|" + "ed25519";
//    final String authHeader = "Signature keyId=\"" + kid + "\",algorithm=\"" + "ed25519" + "\", created=\"" + currentTime + "\", expires=\"" + (currentTime + headerValidity) + "\", headers=\"(created) (expires) digest\", signature=\"" + signature + "\"";
//    return authHeader;

//  if (!StringUtils.isNoneBlank(new CharSequence[] { signing.getPrivateKey() })) {
//    System.out.println("neither certificate nor private key has been set for signature");
//    throw new ApplicationException(ErrorCode.SIGNATURE_ERROR, ErrorCode.SIGNATURE_ERROR.getMessage());
//  }
  final Ed25519PrivateKeyParameters privateKey2 = new Ed25519PrivateKeyParameters(Base64.getDecoder().decode(signing.getPrivateKey().getBytes()), 0);
  System.out.println("Private Key2: "+privateKey2);
  final Ed25519Signer sig = new Ed25519Signer();
  sig.init(true, (CipherParameters)privateKey2);
  sig.update(signingString.getBytes(), 0, signingString.length());
  final byte[] s1 = sig.generateSignature();
  sign = Base64.getEncoder().encodeToString(s1);

      final String kid = "beckn.org-|1" + "|" + "ed25519";
    final String authHeader = "Signature keyId=\"" + kid + "\",algorithm=\"" + "ed25519" + "\", created=\"" + currentTime + "\", expires=\"" + (currentTime + headerValidity) + "\", headers=\"(created) (expires) digest\", signature=\"" + sign + "\"";
    return authHeader;
}catch (Exception e){
  System.out.println(e);
  return null;
}

  }
  public String decrypt(String authHeader,String requestBody){

      System.out.println("AuthHeader"+authHeader);

    String verifyresp;
//    final Map<String, String> headersMap = this.signingUtility.parseAuthorizationHeader(authHeader);
    final Map<String, String> holder = new HashMap<String, String>();
    if (authHeader.contains("Signature ")) {
      authHeader = authHeader.replace("Signature ", "");
      final String[] split;
      final String[] keyVals = split = authHeader.split(",");
      for (final String keyVal : split) {
        final String[] parts = keyVal.split("=", 2);
        if (parts[0] != null && parts[1] != null) {
          holder.put(parts[0].trim(), parts[1].trim());
        }
      }
    }
    final Map<String, String> headersMap=holder;
    KeyIdDto keyIdDto=null;
//    final KeyIdDto keyIdDto = this.signingUtility.splitKeyId(headersMap.get("keyId"));
String kid=headersMap.get("keyId");
      System.out.println("Header KEY ID");
      System.out.println(kid);
    if (kid != null && !kid.isEmpty()) {
      kid = kid.replace("\"", "");
      keyIdDto = new KeyIdDto();
      final String[] a = kid.split("[|]");
      keyIdDto.setKeyId(a[0]);
      keyIdDto.setUniqueKeyId(a[1]);
      keyIdDto.setAlgo(a[2]);
    }
    System.out.println("KEYID");
    System.out.println(keyIdDto.getKeyId());


    final String key = keyIdDto.getKeyId() + "|" + keyIdDto.getUniqueKeyId();
//    HeaderValidator.log.info("BAP key is {}", (Object) key);
    final LookupResponse lookupResponse = new LookupResponse();

    System.out.println("Manually Adding Lookup Details");

    lookupResponse.setSubscriberId("cept.gov.in");
    lookupResponse.setCountry("IND");
    lookupResponse.setCity("*");
    lookupResponse.setDomain("nic2004:60232");
    lookupResponse.setSigningPublicKey("055K6B4y86LTRSgYDzqvtmznYg/ogPidp0d2ZsnidYw=");
    lookupResponse.setEncrPublicKey("MCowBQYDK2VuAyEAWDM2a0h+jAjsRjx1QEzy4seemtzpTd2WCf2Bn9YiPBU=");
    lookupResponse.setValidFrom("2022-04-05T13:01:27.717Z");
    lookupResponse.setValidUntil("2025-04-05T13:01:27.717Z");
    lookupResponse.setCreated("2022-02-07T10:57:44.057Z");
    lookupResponse.setUpdated("2022-02-07T10:57:44.057Z");
    lookupResponse.setType("BPP");
    lookupResponse.setSubscriberUrl("https://gateway.cept.gov.in/ondc/");
    lookupResponse.setBrId("212");
    lookupResponse.setStatus("SUBSCRIBED");
    lookupResponse.setUniqueKeyId("212");

    System.out.println("Manually Adding Lookup Details - Complete");



    System.out.println("Lookup Response is - ");
    System.out.println(lookupResponse);



    //final SigningModel signingModel = this.configService.getSigningConfiguration(subscriberId);

    System.out.println("Ceritificate Used - ");//+ signingModel.isCertificateUsed());

//	        if (signingModel.isCertificateUsed()) {
//	            this.verifySignatureUsingCertificate(headersMap, lookupResponse, requestBody);
//	        }
//	        else {
    verifyresp= this.verifySignatureUsingPublicKey(headersMap, lookupResponse, requestBody);

//	        }
    return verifyresp;

  }



  private String generateBlakeHash(final String req) {
    final Blake2bDigest digest = new Blake2bDigest(512);
    final byte[] test = req.getBytes();
    digest.update(test, 0, test.length);
    final byte[] hash = new byte[digest.getDigestSize()];
    digest.doFinal(hash, 0);
    final String hex = Hex.toHexString(hash);
    return Base64.getUrlEncoder().encodeToString(hex.getBytes());
  }


  public Map<String, String> parseAuthorizationHeader(String authHeader) {
    final Map<String, String> holder = new HashMap<String, String>();
    if (authHeader.contains("Signature ")) {
      authHeader = authHeader.replace("Signature ", "");
      final String[] split;
      final String[] keyVals = split = authHeader.split(",");
      for (final String keyVal : split) {
        final String[] parts = keyVal.split("=", 2);
        if (parts[0] != null && parts[1] != null) {
          holder.put(parts[0].trim(), parts[1].trim());
        }
      }
      return holder;
    }
    return null;
  }
  private String verifySignatureUsingPublicKey(final Map<String, String> headersMap,
                                               final LookupResponse lookupResponse, final String requestBody) {
    final String signed = this.recreateSignedString(headersMap, requestBody);
      boolean isVerified = false;

//    if (!this.signingUtility.verifySignature(headersMap.get("signature").replace("\"", ""), signed,
//            lookupResponse.getSigningPublicKey())) {
////      HeaderValidator.log.error(ErrorCode.SIGNATURE_VERIFICATION_FAILED.toString());
//      return ErrorCode.SIGNATURE_VERIFICATION_FAILED.toString();
////			throw new ApplicationException(ErrorCode.SIGNATURE_VERIFICATION_FAILED);
//
//    }

      final Ed25519PublicKeyParameters publicKeyParams = new Ed25519PublicKeyParameters(Base64.getDecoder().decode(lookupResponse.getSigningPublicKey()), 0);
      final Ed25519Signer sv = new Ed25519Signer();
      sv.init(false, (CipherParameters)publicKeyParams);
      sv.update(signed.getBytes(), 0, signed.length());
      final byte[] decodedSign = Base64.getDecoder().decode(headersMap.get("signature").replace("\"", ""));
      isVerified = sv.verifySignature(decodedSign);
      System.out.println("Verification: "+isVerified);
//      SigningUtility.log.info("Is signature verified ? {}", (Object)isVerified);
//      System.out.println("Is signature verified ? {}", (Object)isVerified);
      if (!isVerified) {
         System.out.println(ErrorCode.SIGNATURE_VERIFICATION_FAILED.toString());
          return ErrorCode.SIGNATURE_VERIFICATION_FAILED.toString();
//			throw new ApplicationException(ErrorCode.SIGNATURE_VERIFICATION_FAILED);

      }

    return "Verified!";
  }
  private String recreateSignedString(final Map<String, String> headersMap, final String requestBody) {
    final String reqBleckHash =generateBlakeHash(requestBody);
    final StringBuilder sb = new StringBuilder();
    sb.append("(created): ");
    sb.append(headersMap.get("created").replace("\"", ""));
    sb.append("\n");
    sb.append("(expires): ");
    sb.append(headersMap.get("expires").replace("\"", ""));
    sb.append("\n");
    sb.append("digest: ");
    sb.append("BLAKE-512=" + reqBleckHash);
    return sb.toString();
  }
}
