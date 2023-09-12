import 'dart:io';

import 'package:intl/intl.dart';

import 'INSURANCE/Utils/DateTimeDetails.dart';

class LogCat {
  String? data;

  String _currentDateTime = "";
  String _onlyDate = "";

  void _getTime() {
    final String formattedDateTime =
        DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now()).toString();
    final String onlyDate =
        DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
    _currentDateTime = formattedDateTime;
    _onlyDate = onlyDate;
    // print(_onlyDate);
  }

  Future<String> get _localPath async {
    Directory directory = Directory('storage/emulated/0/Darpan_Mine/Logs');
    // print("Path is -"+directory.path.toString());
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    _getTime();
    return File('$path/$_onlyDate.txt');
  }

  Future<File> writeContent(String text) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString("${DateTimeDetails().currentDateTime()}: $text\n\n", mode: FileMode.append);
  }

  Future<int?> deleteFile() async {
    try {
      final file = await _localFile;
      file.writeAsStringSync('');
    } catch (e) {
      return 0;
    }
  }
}
