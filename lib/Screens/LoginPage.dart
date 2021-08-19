import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mymovies_app/Screens/HomePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _email, _password;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
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

  login() async {
    FormState? currState = _formKey.currentState;
    if (currState != null) {
      if (currState.validate()) {
        currState.save();

        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email!, password: _password!);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            showError('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            showError('Wrong password provided for that user.');
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
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
                          Icons.login_outlined,
                          size: 120,
                        ),
                      ),
                    ),
                    Container(
                      child: RichText(
                        text: TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 65.0,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Log in to continue",
                      style: TextStyle(fontSize: 18, color: Colors.blueGrey),
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
                                onPressed: login,
                                child: Text(
                                  "Login",
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
