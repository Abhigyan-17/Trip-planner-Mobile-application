import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trip_plan_app/AllScreens/loginScreen.dart';
import 'package:trip_plan_app/AllScreens/mainscreen.dart';
import 'package:trip_plan_app/AllWidgets/progressDialog.dart';
import 'package:trip_plan_app/main.dart';

class RegistrationScreen extends StatelessWidget {
  static const String idScreen = "register";

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView (
        children: [
          SizedBox(height: 20.0,),
          Image(
            image: AssetImage("images/login.jpg"),
            width: 300.0,
            height: 200.0,
            alignment: Alignment.center,
          ),

          SizedBox(height: 5.0,),
          Text(
            "Varanasi Voyage Registration",
            style: TextStyle(fontSize: 20.0, fontFamily: "Brand Bold"),
            textAlign: TextAlign.center,
          ),

          Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: name,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Name",
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
                      controller: phone,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone No.",
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

                    SizedBox(height: 8.0,),
                    ElevatedButton(
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Create an Account",
                            style: TextStyle(fontSize: 10.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (name.text.length<3) {
                          displayToastMessage("Name must be at least 3 characters", context);
                        }
                        else if (!email.text.contains("@")) {
                          displayToastMessage("Invalid Email Address", context);
                        }
                        else if (phone.text.length!=10) {
                          displayToastMessage("Phone number invalid!", context);
                        }
                        else if (password.text.length<7) {
                          displayToastMessage("Password must be atleast 7 characters", context);
                        }
                        else {
                          registerNewUser(context);
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
              Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
            },
            child: Text(
              "Already have an account? Login here!",
            ),
          ),

        ],
      ),
    );
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async
  {
    showDialog(context: context, barrierDismissible: false,
        builder: (BuildContext context){return ProgressDialog(message: "Registering... Please wait",);});
    final User firebaseUser = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.text, password: password.text
    ).catchError((errMsg){Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    })).user;
    if(firebaseUser != null){ usersRef.child(firebaseUser.uid);
      Map userdata = {"Name":name.text.trim(), "Email":email.text.trim(), "Phone":phone.text.trim(),};
      usersRef.child(firebaseUser.uid).set(userdata);
      displayToastMessage("Account Successfully Created!", context);
      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);}
    else{//some error occurred
      Navigator.pop(context);
      displayToastMessage("New user account could NOT be created", context);}}
}

displayToastMessage(String message, BuildContext context){
  Fluttertoast.showToast(msg: message);
}