import 'package:aqarat_apps/data/prepations/single_model.dart';

class prepations {
  List<Singleprepation>? prep;


  prepations({this.prep});

  prepations.fromJson(List<Map<String, dynamic>> list) {
    prep = <Singleprepation>[];
    for (var element in list) {
      prep!.add(Singleprepation.fromJson(element));
    }
  }


}