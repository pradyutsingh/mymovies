import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mymovies_app/Screens/HomePage.dart';
import 'package:mymovies_app/Screens/StartPage.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);

  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _email, _password, _name;
  checkAuthentication() async {
    _auth.authStateChanges().listen(
      (user) {
        // already signed in
        if (user != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => StartPage()));
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  showError(String errormessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ERROR"),
          content: Text(errormessage),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            )
          ],
        );
      },
    );
  }

  signUp() async {
    FormState? currState = _formKey.currentState;
    if (currState != null) {
      if (currState.validate()) {
        currState.save();
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _email!, password: _password!);
          userCredential.user!.updateDisplayName(_name);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            showError('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            showError('The account already exists for that email.');
          }
        } catch (e) {
          print(e);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 150,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: Icon(
                          Icons.app_registration,
                          size: 120,
                        ),
                      ),
                    ),
                    Container(
                      child: RichText(
                        text: TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 65.0,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Register to create account",
                      style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                    ),
                    SizedBox(
                      height: 55,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                child: TextFormField(
                                  validator: (input) {
                                    if (input != null && input.isEmpty) {
                                      return "Enter a valid username";
                                    }
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Username",
                                      prefixIcon: Icon(Icons.verified_user)),
                                  onSaved: (input) => _email = input!,
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  validator: (input) {
                                    if (input != null && input.isEmpty) {
                                      return "Enter Valid Email";
                                    }
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Email",
                                      prefixIcon: Icon(Icons.email)),
                                  onSaved: (input) => _email = input!,
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  validator: (input) {
                                    if (input != null && input.length < 6) {
                                      return "Enter a better password";
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    prefixIcon: Icon(Icons.password),
                                  ),
                                  obscureText: true,
                                  onSaved: (input) => _password = input!,
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.black,
                                  padding: EdgeInsets.all(10),
                                ),
                                onPressed: signUp,
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
