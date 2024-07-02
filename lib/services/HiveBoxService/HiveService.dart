import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

class HiveService {
  static Future<void> initHive() async {
    final appDocumentDir =
        await pathProvider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
  }

  Future<void> writeData(String boxName, Map<String, dynamic> data) async {
    if (Hive.isBoxOpen(boxName)) {
      var box = Hive.box(boxName);
      await box.putAll(data);
    } else if (await Hive.boxExists(boxName)) {
      var box = await Hive.openBox(boxName);
      await box.putAll(data);
    } else {
      throw Exception('Box $boxName does not exist');
    }
  }

  Future<Map<String, dynamic>> readData(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      var box = Hive.box(boxName);
      return Map<String, dynamic>.from(box.toMap());
    } else if (await Hive.boxExists(boxName)) {
      var box = await Hive.openBox(boxName);
      return Map<String, dynamic>.from(box.toMap());
    } else {
      throw Exception('Box $boxName does not exist');
    }
  }
}
