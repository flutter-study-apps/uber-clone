import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './home.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
   bool isAuth = false;
   


  @override
	  void initState(){
	    super.initState();
	    googleSignIn.onCurrentUserChanged.listen((account){
	      if(account!=null){
	        print('user Signed in! ${account.displayName}');
	        setState(() {
	          isAuth = true;
	        });
	      } else{
	         setState(() {
	           isAuth = false;
	         });
	      }
	    });
  }

   login(){
     googleSignIn.signIn();
   }

  @override
  Widget build(BuildContext context) {
    return isAuth ?   MyHomePage(title: 'Sundo') : buildUnAuthScreen();
  }

  	Scaffold buildUnAuthScreen(){
	  return Scaffold(
	    body: Container(
	      decoration: BoxDecoration(
	        gradient: LinearGradient(
	          begin: Alignment.topRight,
	          end: Alignment.bottomLeft,
	          colors: [
	            Colors.teal,
	            Colors.purple,
	          ]
	        ),
	      ),
	      alignment: Alignment.center,
	      child: Column(
	      mainAxisAlignment: MainAxisAlignment.center ,
	      crossAxisAlignment: CrossAxisAlignment.center,
	        children: <Widget>[
	          Text(
	            'Sundo',
	            style: TextStyle(
	              fontFamily: "Signatra",
	              fontSize: 60.0,
	              color: Colors.white,
	            ),
	          ),
	          SizedBox(
	            height: 30,
	          ),
	          // to detect the gesture on the image. 
	          GestureDetector(
	            // onTap: (){print('Tapped');},
	            onTap: login(),
	            child: Container(
	              width: 260,
	              height: 60,
	              decoration: BoxDecoration(
	                image: DecorationImage(
	                  image: AssetImage('assets/images/google_signin_button.png'),
	                  fit: BoxFit.cover
	                ),
	              ),
	            ),
	          ),
	        ], 
	      ),
	    ),
	  );
  }


}



