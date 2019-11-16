
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uberclone/states/app_states.dart';
import 'screens/home.dart';
import './screens/signIn_screen.dart';



// void main() => WidgetsFlutterBinding.ensureInitialized() =>runApp(
//   //if we do big app, use multiprovider, so that we can use multiple provider for different concerns
//   MultiProvider(
//     providers: [
//       ChangeNotifierProvider.value(value: AppState(),)
//     ],
//     child: MyApp(),
//   )
// );

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(MultiProvider(providers: [
      ChangeNotifierProvider.value(value: AppState(),)
  ],
  child: MyApp(),));
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sundo',
      theme: ThemeData(
        primaryColor:Colors.deepPurple,
        accentColor:Colors.teal,primarySwatch: Colors.blue,
      ),
      home: SignInScreen() ,
      // home: MyHomePage(title: 'Sundo'),
    );

  }
}