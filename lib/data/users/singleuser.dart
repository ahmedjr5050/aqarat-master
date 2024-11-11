class Singleuser{
  String? id;
  int? age;
  String? region;
  String? email;
  String? name;
  List<String> imageUrls = [];
  int? id_roles;


  Singleuser(
      {this.id,
        this.age,
        this.email,
        List<String>? imageUrls,
        this.name,
        this.region,
        this.id_roles,
      }) : imageUrls = imageUrls ?? [];

  Singleuser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    age = json['age'];
    email = json['email'];
    imageUrls = List<String>.from(['imageUrls'] ?? []); // تحويل الصور إلى قائمة من السلاسل
    name = json['name'];
    region = json['region'];
    id_roles = json['id_roles'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['age'] = age;
    data['email'] = email;
    data['imageUrls'] = imageUrls;
    data['name'] = name;
    data['region'] = region;
    data['id_roles'] = id_roles;
    return data;
  }


}

