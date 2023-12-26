import 'dart:developer';

import '../../utils/api.dart';
import '../model/outdoor_facility.dart';

class OutdoorFacilityRepository {
  Future<List<OutdoorFacility>> fetchOutdoorFacilityList() async {
    Map<String, dynamic> result =
        await Api.get(url: Api.getOutdoorFacilites, queryParameters: {});
    log("DATA IsS ${result['data']}");

    List<OutdoorFacility> outdoorFacilities =
        (result['data'] as List).map((element) {
      return OutdoorFacility.fromJson(element);
    }).toList();

    // log("RESULT IS ${outdoorFacilities.map((element) => element.)}");

    return List.from(outdoorFacilities);
  }
}
