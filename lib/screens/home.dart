import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:uberclone/requests/google_maps_request.dart';
import 'package:uberclone/screens/signIn_screen.dart';
import 'package:uberclone/states/app_states.dart';
import 'package:google_sign_in/google_sign_in.dart';


final GoogleSignIn googleSignIn = GoogleSignIn();

// import 'autocomplete.dart';
// import '../requests/google_maps_request.dart';
// import '../utils/core.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class MyHomePage extends StatefulWidget {
  // to receive data from the call, constructor 
  static String id='home_screen';

  MyHomePage({Key key, this.title}):super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Map(),
      // bottomNavigationBar: BottomNavigationBar(
      //   // items: ,
      // ),
      floatingActionButton: FloatingActionButton(
      onPressed: (){
        //  googleSignIn.signOut().then(console.log);
        googleSignIn.signOut();
         Navigator.pushNamed(context, SignInScreen.id);
      },
        child: Icon(Icons.exit_to_app),
      ),
    );
  }
}

class Map extends StatefulWidget { 
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
 


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return    appState.initalPosition == null? 
      Container(
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 20,),
              Text("Please enable location services!", style: TextStyle(color: Colors.grey, fontSize: 18),),
            ],
          ),
        ),
      ) :
      Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(target: appState.initalPosition,   zoom: 16.0,),
            onMapCreated: appState.onCreated,
            myLocationEnabled: true,
            mapType: MapType.normal,
            compassEnabled: true,
            markers: appState.markers,
            onCameraMove: appState.onCameraMove,
            polylines: appState.polyline,
            
          ),
           Visibility(
             visible: appState.autoCompleteContainer==true,
                child: Container(
                  margin: EdgeInsets.fromLTRB(15, 180, 15, 0),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1.0, 5.0),
                        blurRadius: 10,
                        spreadRadius: 3)
                    ],
                  ),
                  child: FutureBuilder(
                    future: appState.getCountries(),
                    initialData: [],
                    builder: (context,snapshot){
                      return  createCountriesListView(context, snapshot);
                    },
                  ),
              ),
           ),
          Positioned(
            top: 50.0,
            right: 15.0,
            left: 15.0,
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(1.0, 5.0),
                      blurRadius: 10,
                      spreadRadius: 3)
                ],
              ),
              child: TextField(
                cursorColor: Colors.black,
                controller: appState.locationController,
                decoration: InputDecoration(
                  icon: Container(
                    margin: EdgeInsets.only(left: 20, top: 5),
                    width: 10,
                    height: 10,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.black,
                    ),
                  ),
                  hintText: "pick up",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                ),
              ),
            ),
          ),

          Positioned(
            top: 105.0,
            right: 15.0,
            left: 15.0,
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(1.0, 5.0),
                      blurRadius: 10,
                      spreadRadius: 3)
                ],
              ),
              child: TextField(
                
                cursorColor: Colors.black,
                controller:  appState.destinationControler,
                textInputAction: TextInputAction.go,
                onSubmitted: (value) {
                  // appState.autoCompleteContainer = false;
                  // appState.autoCompleteContainer = false;
                  appState.visibilityAutoComplete(false);
                  appState.sendRequest(value);
                  // appState.autoCompleteContainer = false;
                },
                onChanged: (value){
                  appState.increment();
                  // appState.autoCompleteContainer = true;
                  if(appState.destinationControler.text!=null){
                    appState.autoCompleteContainer = true;
                  }else{
                    appState.autoCompleteContainer = false;
                  }
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: (){
                      // appState.destinationControler.text="";
                      appState.clearDestination();
                      // GoogleMap
                      
                    },
                  ),
                  icon: Container(
                    margin: EdgeInsets.only(left: 20, top: 5),
                    width: 10,
                    height: 10,
                    child: Icon(
                      Icons.local_taxi,
                      color: Colors.black,
                    ),
                  ),
                  hintText: "destination?",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                ),
              ),
            ),
          ),
          // Positioned(
          //   top: 40, right: 10,
          //   // child: FloatingActionButton(onPressed: _onAddMarkerPressed, tooltip: "Add Map",),
          //   child: FloatingActionButton( 
          //     onPressed: _onAddMarkerPressed,
          //     backgroundColor: Black,
          //     child: Icon(Icons.add_location,color:White),
          //     ),
          // ),
        ],
      );

  }

  Widget createCountriesListView(BuildContext context, AsyncSnapshot snapshot) {
    var values = snapshot.data;
    return ListView.builder(
      shrinkWrap: true,
    itemCount: values == null ? 0 : values.length,
    itemBuilder: (BuildContext context, int index) {
      final appState = Provider.of<AppState>(context);

      return GestureDetector(
      onTap: () {
        // setState(() {
        // selectedCountry = values[index].code;
        appState.selectedPlace = values[index].description;
        appState.sendRequest(values[index].description);
        appState.visibilityAutoComplete(false);
        // });

        appState.destinationControler.text=appState.selectedPlace.toString();
        appState.sendRequest(appState.toString());
        //  appState.sendRequest(value);
        // print(values[index].code);
        print(appState.selectedPlace);
      },
      child: Column(
        children: <Widget>[
        new ListTile(
          title: Text(values[index].description),
        ),
        Divider(
          height: 2.0,
        ),
        ],
      ),
      );
    },
    );
  }

}