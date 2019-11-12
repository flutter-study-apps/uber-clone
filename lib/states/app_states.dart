import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uberclone/requests/google_maps_request.dart';
import '../screens/autocomplete.dart';

class AppState with ChangeNotifier{
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  GoogleMapController _mapController;
  int _autoComplete =  0;


  // Setters
  GoogleMapsServices _googleMapServices  = GoogleMapsServices();
  TextEditingController locationController =TextEditingController();
  TextEditingController destinationControler=TextEditingController();
  // num _autoComplete = 0;

  // Getters
  LatLng get initalPosition => _initialPosition;
  LatLng get lastPosition => _lastPosition;
  GoogleMapsServices get googleMapServices => _googleMapServices;
  GoogleMapController get mapController =>_mapController;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polyline => _polyLines;
  num get autocomplete => _autoComplete;



  //constructor for getuserlocation
  AppState(){
    _getUserLocation();
  }


  void increment(){
    _autoComplete +=1;
    notifyListeners();
  }

  void _getUserLocation() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark =  await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude); 
      _initialPosition=LatLng(position.latitude, position.longitude); 

      locationController.text = placemark[0].subThoroughfare + ' ' + placemark[0].thoroughfare + ', ' +placemark[0].locality;
      notifyListeners();
  }
 

  // On Create
  void onCreated(GoogleMapController controller) { 
    _mapController = controller;
    notifyListeners();
  }
                
   

  //Create Polyline as Map Route
  void createRoute(String encodedPoly){
    _polyLines.clear();
      _polyLines.add(Polyline(
        polylineId: PolylineId(_lastPosition.toString()),
        width: 3,
        points: _convertToLatLng(_decodePoly(encodedPoly)),
        color: Colors.black),
      );
      notifyListeners();
  } 

  //Add Marker in Map
  void _addMarker(LatLng location, String address) {
    _markers.add(
      Marker(
        markerId:MarkerId(_lastPosition.toString()),
        position: location,
        infoWindow: InfoWindow( 
          title: "Address",
          snippet: "Go Here",
        ),
        icon: BitmapDescriptor.defaultMarker, //the actual design of the pin in the map
      ),
    ); 
    notifyListeners();
  }  

  //On Camera Move
  void onCameraMove(CameraPosition position) {
      _lastPosition = position.target; 
      notifyListeners();
  }   

  // When the user type something in the textbox it will show the placemark 
  void sendRequest(String intendedLocation)async{
    List<Placemark> placemark = await Geolocator().placemarkFromAddress(intendedLocation); 
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude, longitude);
    _addMarker(destination, intendedLocation); 
    String route = await _googleMapServices.getRouteCoordinates(initalPosition, destination);
    createRoute(route);
    notifyListeners();
  }

  // Convert the list of points to LatLng
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  // Decode the poly response from google map api
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    // repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);
  
    /*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }




}