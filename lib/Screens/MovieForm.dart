import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:mymovies_app/models/Movie.dart';
import 'package:mymovies_app/utils/DataBase_helper.dart';

class MovieForm extends StatefulWidget {
  // const MovieForm({Key? key}) : super(key: key);
  final String? appBarTitle;
  final Movie movie;
  MovieForm(this.movie, this.appBarTitle);
  @override
  _MovieFormState createState() => _MovieFormState();
}

class _MovieFormState extends State<MovieForm> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // String? _movieName, _directorName;
  XFile? _image;
  File? _imageFile;
  String? _base64Image;

  TextEditingController movienameController = TextEditingController();
  TextEditingController moviedirectorController = TextEditingController();
  DataBaseHelper helper = DataBaseHelper();

  _imgFromCamera() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
      _imageFile = File(_image!.path);
      List<int> imageBytes = _imageFile!.readAsBytesSync();
      _base64Image = base64Encode(imageBytes);
      print(_base64Image);
    });
    widget.movie.imageCode = _base64Image;
  }

  _imgFromGallery() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    // var _imageFile = File(image!.path);
    setState(() {
      _image = image;
      _imageFile = File(_image!.path);
      List<int> imageBytes = _imageFile!.readAsBytesSync();
      _base64Image = base64Encode(imageBytes);
      print(_base64Image);
    });
    widget.movie.imageCode = _base64Image;
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
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

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  String validateName(String value) {
    if (value.isEmpty) {
      return "Enter the name of movie";
    }
    return "All good";
  }

  String validatedirector(String value) {
    if (value.isEmpty) {
      return "Enter the name of director";
    }
    return "All good";
  }

  void updateMovieName() {
    widget.movie.movieName = movienameController.text;
  }

  void updateDirector() {
    widget.movie.director = moviedirectorController.text;
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _save() async {
    moveToLastScreen();
    int result;
    print("movie name ${widget.movie.movieName}");
    print("move director${widget.movie.director}");
    print("movie image ${widget.movie.imageCode}");
    if (widget.movie.id != null) {
      // Case 1: Update operation
      result = await helper.updateMovie(widget.movie);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertMovie(widget.movie);
    }
    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Movie Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Movie');
    }
  }

  @override
  Widget build(BuildContext context) {
    moviedirectorController.text = widget.movie.director!;
    movienameController.text = widget.movie.movieName!;
    bool shouldpop = true;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amberAccent,
        child: Icon(
          Icons.done,
          color: Colors.black,
        ),
        onPressed: _save,
      ),
      appBar: AppBar(
        title: Text(widget.appBarTitle!),
        backgroundColor: Colors.amberAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            moveToLastScreen();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Column(
                children: [
                  Container(
                    child: TextField(
                      controller: movienameController,
                      decoration: InputDecoration(
                        labelText: "Movie name",
                        prefixIcon: Icon(Icons.movie),
                        errorText: validateName(movienameController.text),
                      ),
                      onChanged: (value) {
                        debugPrint(value);
                        updateMovieName();
                      },
                    ),
                  ),
                  Container(
                    child: TextField(
                      controller: moviedirectorController,
                      decoration: InputDecoration(
                        labelText: "Movie Director",
                        errorText:
                            validatedirector(moviedirectorController.text),
                        prefixIcon: Icon(
                          Icons.video_camera_back,
                        ),
                      ),
                      onChanged: (value) {
                        updateDirector();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 32,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Color(0xffFDCF09),
                    child: _base64Image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.file(
                              _imageFile!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.fitHeight,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(50)),
                            width: 100,
                            height: 100,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
