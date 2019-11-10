import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uberclone/states/app_states.dart';
import 'screens/home.dart';

void main() => runApp(
  //if we do big app, use multiprovider, so that we can use multiple provider for different concerns
  MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: AppState(),)
    ],
    child: MyApp(),
  )
);


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sundo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Sundo'),
    );

  }
}