import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart'; //convert json 
const   apiKey = "AIzaSyB8jxZ33qr3HXTSKgXqx0mXbzQWzLjnfLU";

class GoogleMapsServices {
  Future<String> getRouteCoordinate(LatLng l1, LatLng l2) async{
    //request response of google map api

    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey";
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    return values["routes"][0]["overview_polyline"]["points"];
  }
}