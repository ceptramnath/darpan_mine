import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../LogCat.dart';

class SharedPreferenceService {
  SharedPreferences? _prefs;

  Future<bool> getSharedPreferencesInstance() async {
    _prefs = await SharedPreferences.getInstance().catchError((e) {
      print("shared prefrences error : $e");
      return false;
    });
    return true;
  }

  Future<int> getScannerValue() async {
    _prefs = await SharedPreferences.getInstance();
    int scannerValue = _prefs!.getInt('scanner_value') ?? 4;
    return scannerValue;
  }

  Future setScannerType(int? scanner) async {
    _prefs = await SharedPreferences.getInstance().catchError((e) async {
      await LogCat().writeContent(
          '${DateTimeDetails().currentDateTime()} : $runtimeType : $e.\n\n');
    });
    _prefs!.setInt("scanner_value", scanner!);
  }

  Future setAccessToken(String token) async {
    print('Inside setAccessToken: ' + token);
    _prefs = await SharedPreferences.getInstance().catchError((e) async {
      print(runtimeType);
    });
    await _prefs!.setString('atoken', token);
    print('atoken in shared pref: ' + token);
  }

  Future<String?> getAccessToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? did = _prefs.getString('atoken');
    return did;
  }

  Future setRefreshToken(String token) async {
    print('Inside setRefreshToken: ' + token);
    _prefs = await SharedPreferences.getInstance().catchError((e) async {
      print(runtimeType);
    });
    await _prefs!.setString('rtoken', token);
    print('rtoken in shared pref: ' + token);
  }

  Future<String?> getRefreshToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? did = _prefs.getString('rtoken');
    return did;
  }

  Future setTimer(String token) async {
    print('Inside setTimer: ' + token);
    _prefs = await SharedPreferences.getInstance().catchError((e) async {
      print(runtimeType);
    });
    await _prefs!.setString('atimer', token);
    print('timer in shared pref: ' + token);
  }

  Future<String?> getTimer() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? did = _prefs.getString('atimer');
    return did;
  }

  Future setAccessTime(String token) async {
    print('Inside setTimer: ' + token);
    _prefs = await SharedPreferences.getInstance().catchError((e) async {
      print(runtimeType);
    });
    await _prefs!.setString('atokentimer', token);
    print('timer in shared pref: ' + token);
  }

  Future<String?> getAccessTime() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? did = _prefs.getString('atokentimer');
    return did;
  }

  Future<String?> get token async => _prefs!.getString('token');

  Future setDevID(String devid) async {
    _prefs = await SharedPreferences.getInstance().catchError((e) async {
      // await LogCat().writeContent('${DateTimeDetails().currentDateTime()} : $runtimeType : $e.\n\n');
    });
    _prefs?.setString('DeviceID', devid);
  }

  Future<String?> getDevID() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? did = _prefs.getString('DeviceID');
    return did;
  }
}

SharedPreferenceService sharedPreferenceService = SharedPreferenceService();
