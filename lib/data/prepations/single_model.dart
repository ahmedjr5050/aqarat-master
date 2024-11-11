class Singleprepation{
  String? id;
  String? catId;
  String? description;
  String? title;
  String? type;
  List<String> imageUrls = [];
  String? userId;
  int? price;


  Singleprepation(
      {this.id,
        this.catId,
        this.description,
        List<String>? imageUrls,
        this.title,
        this.type,
        this.userId,
        this.price,
      }) : imageUrls = imageUrls ?? [];

  Singleprepation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    catId = json['catId'];
    description = json['description'];
    imageUrls = List<String>.from(['Picture'] ?? []); // تحويل الصور إلى قائمة من السلاسل
    type = json['type'];
    title = json['title'];
    userId = json['userId'];
    price = json['Price'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['catId'] = catId;
    data['description'] = description;
    data['Picture'] = imageUrls;
    data['type'] = type;
    data['userId'] = userId;
    data['Price'] = price;
    data['title'] = title;
    return data;
  }


}

