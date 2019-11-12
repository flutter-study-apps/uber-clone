import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import '../states/app_states.dart';

String selectedPlace = "";

class AutoComplete extends StatefulWidget {
  // String distination;
  // AutoComplete(this.distination);
  String destination ;
  AutoComplete(this.destination);
  @override
  _AutoCompleteState createState() => _AutoCompleteState();
}

class _AutoCompleteState extends State<AutoComplete> {
  
  final String API_key = "f4a9c45af1bcfe5847070bf3943e778e";
  
  
  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
      future: getCountries(),
      initialData: [],
      builder: (context,snapshot){
        return createCountriesListView(context, snapshot);
      },
    );




  }

 Widget createCountriesListView(BuildContext context, AsyncSnapshot snapshot) {
  var values = snapshot.data;
  return ListView.builder(
   itemCount: values == null ? 0 : values.length,
   itemBuilder: (BuildContext context, int index) {
    final appState = Provider.of<AppState>(context);

    return GestureDetector(
     onTap: () {
      setState(() {
       // selectedCountry = values[index].code;
       selectedPlace = values[index].description;
      
      });

       appState.destinationControler.text=selectedPlace.toString();
       appState.sendRequest(selectedPlace.toString());
      //  appState.sendRequest(value);
      // print(values[index].code);
      print(selectedPlace);
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





Future<List<SuggestedPlaces>>getCountries() async{
  final response = await http .get('https://maps.googleapis.com/maps/api/place/queryautocomplete/json?key=AIzaSyB8jxZ33qr3HXTSKgXqx0mXbzQWzLjnfLU&input=${destination}');

  if(response.statusCode == 200){
    var parsedPlacesList = json.decode(response.body);

    List<SuggestedPlaces> suggestedPlaces = List<SuggestedPlaces>();

    parsedPlacesList["predictions"].forEach((suggestedPlace){
      suggestedPlaces.add(SuggestedPlaces.fromJSON(suggestedPlace));
    });
    
    return suggestedPlaces;
  }else{
    throw Exception('Failed to load');
  }

}


class SuggestedPlaces {
  String description;

  SuggestedPlaces({this.description,});

  factory SuggestedPlaces.fromJSON(Map<String,dynamic>json){
    return SuggestedPlaces(
      description: json['description'],
    );
  }


}