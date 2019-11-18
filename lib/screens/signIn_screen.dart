import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './home.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class SignInScreen extends StatefulWidget {
  static String id = "signIn_screen";
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
	    body: Stack(
	      children: <Widget>[
          Positioned(
             child:         Container(
	          decoration: BoxDecoration(
	            gradient: LinearGradient(
	              begin: Alignment.topRight,
	              end: Alignment.bottomLeft,
	              colors: [
              Color.fromRGBO(15, 190, 216,1),
              Color.fromRGBO(20, 201, 203,1),
              Color.fromRGBO(27, 215, 187,1),
              Color.fromRGBO(34, 228, 172,1),
              Color.fromRGBO(42, 245, 152,1),
	              ]
	            ),
	          ),
	          alignment: Alignment.center,
	          child: Column(
	          mainAxisAlignment: MainAxisAlignment.center ,
	          crossAxisAlignment: CrossAxisAlignment.center,
	            children: <Widget>[
	              Text(
	                'Byahero',
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
	                  width: 100,
	                  height: 43,
	                  decoration: BoxDecoration(
	                    image: DecorationImage(
	                      image: AssetImage('assets/images/google_signin_button_2.png'),
	                      fit: BoxFit.cover
	                    ),
	                  ),
	                ),
	              ),
	            ], 
	          ),
	        ),
          
          ),
          Positioned(
            bottom: 30,
            child: Text("fdfd"),
          ),
          
	
        
        ],
	    ),

	  );
  }
}



