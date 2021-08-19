import 'package:flutter/material.dart';
import 'package:mymovies_app/Screens/LoginPage.dart';
import 'package:mymovies_app/Screens/RegisterUser.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  navigateToLogin() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  navigateToRegister() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterUser()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                        height: 170,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          child: Icon(
                            Icons.movie_outlined,
                            size: 120,
                          ),
                        ),
                      ),
                      Container(
                        child: RichText(
                          text: TextSpan(
                            text: 'Binge ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 65.0,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'next',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 65.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Text(
                        "Your daily binge routine",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 55,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              padding: EdgeInsets.all(10),
                            ),
                            onPressed: navigateToLogin,
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                                padding: EdgeInsets.all(10),
                              ),
                              onPressed: navigateToRegister,
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
