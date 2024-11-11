class Singlecomment{
  String? id;
  String? commentText;
  DateTime? createdat;
  String? prorId;
  String? userId;


  Singlecomment(
      {this.id,
        this.commentText,
        this.createdat,
        this.prorId,
        this.userId,
      });

  Singlecomment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commentText = json['commentText'];
    createdat = json['createdat'];
    prorId = json['prorID'];
    userId = json['userID'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['commentText'] = commentText;
    data['prorID'] = prorId;
    data['createdat'] = createdat;
    data['userID'] = userId;
    return data;
  }


}

