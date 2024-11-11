

import 'package:aqarat_apps/data/roles/role_model.dart';

class Roles {
  List<Role>? roles;


  Roles({this.roles});

  Roles.fromJson(List<Map<String, dynamic>> list) {
    roles = <Role>[];
    for (var element in list) {
      roles!.add(Role.fromJson(element));
    }
  }


}