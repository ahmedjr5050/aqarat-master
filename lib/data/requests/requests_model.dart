import 'package:aqarat_apps/data/requests/singlereq_model.dart';

class Requests {
  List<Singlereq>? request;


  Requests({this.request});

  Requests.fromJson(List<Map<String, dynamic>> list) {
    request = <Singlereq>[];
    for (var element in list) {
      request!.add(Singlereq.fromJson(element));
    }
  }


}