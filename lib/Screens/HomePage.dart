import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mymovies_app/Screens/MovieForm.dart';
import 'package:mymovies_app/Screens/StartPage.dart';
import 'package:mymovies_app/models/Movie.dart';
import 'package:mymovies_app/utils/DataBase_helper.dart';
import 'package:mymovies_app/widgets/MovieCard.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoggedin = false;
  User? user;
  DataBaseHelper databaseHelper = DataBaseHelper();
  List<Movie>? movieList;
  int count = 0;

  checkAuthentication() async {
    _auth.authStateChanges().listen(
      (user) {
        if (user == null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => StartPage()));
        }
      },
    );
  }

  getUser() async {
    User firebaseUser = _auth.currentUser!;
    this.user = firebaseUser;
    this.isLoggedin = true;
  }

  signOut() async {
    _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    if (movieList == null) {
      movieList = [];
      updateListView();
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amberAccent,
        onPressed: () {
          navigateToForm(Movie('', '', ''), "Add movie");
        },
        child: Icon(Icons.add, color: Colors.black),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.amberAccent,
        title: Text(
          "Your movies",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Container(
        // color: Colors.teal[100],
        child: !isLoggedin ? CircularProgressIndicator() : getNoteListView(),
      ),
    );
  }

  Widget getNoteListView() {
    return count == 0
        ? Center(
            child: Text(
            "Its empty here :(",
            style: TextStyle(
                fontSize: 15,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold),
          ))
        : ListView.builder(
            itemCount: count,
            itemBuilder: (BuildContext context, int position) {
              return Card(
                // color:
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.only(top: 10, left: 15),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0), //or 15.0
                        child: Container(
                          height: 85.0,
                          width: 75.0,
                          color: Colors.white,
                          child: Image.memory(
                            Base64Decoder()
                                .convert(this.movieList![position].imageCode!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        this.movieList![position].movieName!,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Movie by ${this.movieList![position].director!}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () =>
                              _delete(context, movieList![position]),
                          icon: Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            navigateToForm(
                                this.movieList![position], 'Edit movie');
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.greenAccent,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
  }

  void navigateToForm(Movie movie, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MovieForm(movie, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void _delete(BuildContext context, Movie movie) async {
    int result = await databaseHelper.deleteNote(movie.id!);
    if (result != 0) {
      _showSnackBar(context, 'Movie Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Movie>> movieListFuture = databaseHelper.getMovieList();
      movieListFuture.then((movieList) {
        setState(() {
          this.movieList = movieList;
          this.count = movieList.length;
        });
      });
    });
  }
}
