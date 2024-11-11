class Role{
  String? id;
  String? catname;


  Role(
      {this.id,
        this.catname,
      }) ;

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    catname = json['catname'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['catname'] = catname;
    return data;
  }


}

