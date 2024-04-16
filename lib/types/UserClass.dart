import 'package:hive/hive.dart';

part 'UserClass.g.dart';

@HiveType(typeId: 1)
class UserClass {
  @HiveField(0)
  String? email;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? password;

  UserClass({
    this.email,
    this.name,
    this.password,
  });
}
