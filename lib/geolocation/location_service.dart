import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  final String key = 'AIzaSyBAnEPRuGpAbvsbHaZUsi6uMWIUOzhtzuY';

  Future<String> getPlaceId(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);

    final placeId = json['candidates'][0]['place_id'] as String;
    print(placeId);
    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);
    final results = json['result'] as Map<String, dynamic>;
    print(results);
    return results;
  }
}
