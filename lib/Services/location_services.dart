import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationServices{
  final String key = "AIzaSyCqxwRwQnYK4_cZ6I3El5SlGN3Im_Y4yp4";

  Future<String> getPlaceId(String input) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId =  json['candidates'][0]['place_id'] as String;
    print("IDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD: "+placeId);
    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var place =  json['result'] as Map<String, dynamic>;
    return place;
  }

  Future<void> getDirection() async {

  }
}