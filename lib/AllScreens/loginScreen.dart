import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:trip_plan_app/AllScreens/mainscreen.dart';
import 'package:trip_plan_app/AllScreens/registrationScreen.dart';
import 'package:trip_plan_app/AllWidgets/progressDialog.dart';
import 'package:trip_plan_app/main.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 50.0,),
          Image(image: AssetImage("images/login.jpg"), width: 300.0, height: 200.0,
              alignment: Alignment.center,),

          SizedBox(height: 5.0,),
          Text("Login to Varanasi Voyage",
            style: TextStyle(fontSize: 20.0, fontFamily: "Brand Bold"),
            textAlign: TextAlign.center,),

          Padding(
              padding: EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(height: 1.0,),
                      TextField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0
                            ),
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),

                      SizedBox(height: 1.0,),
                      TextField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0
                          ),
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),

                      SizedBox(height: 10.0,),
                      ElevatedButton(
                          child: Container(
                            height: 50.0,
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(fontSize: 10.0, fontFamily: "Brand Bold"),
                              ),
                            ),
                          ),
                          onPressed: ()
                          {
                            if (!email.text.contains("@")) {
                              displayToastMessage("Invalid Email Address", context);
                            }
                            else if (password.text.isEmpty) {
                              displayToastMessage("Enter password", context);
                            }
                            else {
                              loginAndAuthenticateUser(context);
                            }
                          },
                      ),
                    ],
                  ),
                ),
              ),
          ),

          // ignore: deprecated_member_use
          FlatButton(
            onPressed: ()
            {
              Navigator.pushNamedAndRemoveUntil(context, RegistrationScreen.idScreen, (route) => false);
            },
            child: Text(
              "Do not have an account? Register here!",
              // style: TextStyle(fontSize: 8.0, fontFamily: "Brand Bold"),
            ),
          ),

        ],
      ),
    );
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAndAuthenticateUser(BuildContext context) async{
    showDialog(
        context: context, barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressDialog(message: "Authenticating... Please wait",);});
    final User firebaseUser = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email.text, password: password.text).catchError((errMsg){Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    })).user;
    if(firebaseUser != null) {
      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
          displayToastMessage("Login Successful!", context);}
        else {Navigator.pop(context);_firebaseAuth.signOut();
          displayToastMessage("No connected account found! Please create new account", context);
        }
      });
    }
    else{//some error occurred
      Navigator.pop(context);
      displayToastMessage("Error occurred. Can not sign-in", context);
    }
  }
}
