
import 'package:aqarat_apps/data/comments/singlecomm.dart';

class Comments {
  List<Singlecomment>? comm;


  Comments({this.comm});

  Comments.fromJson(List<Map<String, dynamic>> list) {
    comm = <Singlecomment>[];
    for (var element in list) {
      comm!.add(Singlecomment.fromJson(element));
    }
  }


}