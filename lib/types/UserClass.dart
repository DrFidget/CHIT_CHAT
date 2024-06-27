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
  @HiveField(3)
  String? timeStamp;
  @HiveField(4)
  String? ID;
  @HiveField(5)
  String? imageLink;
  //piture
  //bio
  //

  UserClass({
    this.email,
    this.name,
    this.password,
    this.timeStamp,
    this.ID,
    this.imageLink,

  });
  factory UserClass.fromJson(Map<String, dynamic> json) {
    return UserClass(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      timeStamp: json['timeStamp'],
      ID: json['ID'],
      imageLink: json['imageLink'],
    );
  }
  void printUser() {
    print('Name: $name');
    print('Email: $email');
    print('Password: $password');
    print('Timestamp: $timeStamp');
    print('ID: $ID');
    print('ImageLink: $imageLink');
  }
  // UserClass.fromMap(Map<String, dynamic> json)
}
