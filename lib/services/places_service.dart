import 'package:trip_plan_app/Map_geometry/place.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:trip_plan_app/configMaps.dart';

class PlacesService {
  static String place = 'atm';
  Future<List<Place>> getPlaces(double lat, double lng) async {
    var response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&type=$place&rankby=distance&key=$mapKey'));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    return jsonResults.map((place) => Place.fromJson(place)).toList();
  }
}
