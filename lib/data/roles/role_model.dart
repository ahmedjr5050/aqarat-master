class Role{
  String? id;
  int? role_id;
  String? role_name;


  Role(
      {this.id,
        this.role_name,
        this.role_id,
      }) ;

  Role.fromJson(Map<String, dynamic> json) {
    role_id = json['role_id'];
    id = json['id'];
    role_name = json['role_name'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role_id'] = role_id;
    data['id'] = id;
    data['role_name'] = role_name;
    return data;
  }


}

