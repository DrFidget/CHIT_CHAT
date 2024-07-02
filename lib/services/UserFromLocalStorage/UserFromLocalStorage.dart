import 'package:hive/hive.dart';
import 'package:ourappfyp/types/UserClass.dart';

class UserLocalStorageService {
  static const String userBoxName = 'userBox';

  Future<String?> getUserID() async {
    try {
      final _myBox = await Hive.openBox<UserClass>(userBoxName);
      final UserClass? user = await _myBox.get(1);
      return user?.ID;
    } catch (error) {
      print('Error fetching user ID from local storage: $error');
      return null;
    }
  }
}
