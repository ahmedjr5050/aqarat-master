import 'dart:ffi';

class Singlereq{
  String? id;
  String? proId;
  DateTime? requestDate;
  Bool? status;
  String? userId;


  Singlereq(
      {this.id,
        this.userId,
        this.proId,
        this.requestDate,
        this.status,
      });

  Singlereq.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userID'];
    proId = json['prorId'];
    requestDate = json['requestDate'];
    status = json['status'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userID'] = userId;
    data['prorId'] = proId;
    data['requestDate'] =requestDate;
    data['status'] = status;
    return data;
  }


}

