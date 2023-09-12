import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<String> get _localPath async {
  Directory directory = Directory('storage/emulated/0/Darpan_Mine/Reports');
  // print("Path is -"+directory.path.toString());
  return directory.path;
}

Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  final path = await _localPath;
  // final path=(await getExternalStorageDirectory()).Dire;
  final file = File('$path/$fileName');
  await file.writeAsBytes(bytes, flush: true);
  OpenFile.open('$path/$fileName');
}
