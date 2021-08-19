import 'dart:core';

class Movie {
  int? _id;
  String? _movieName;
  String? _director;
  String? _imageCode;

  Movie(this._movieName, this._director, this._imageCode);
  Movie.withID(this._id, this._movieName, this._director, this._imageCode);

  int? get id => _id;
  // get moviename => _movieName;
  String? get movieName {
    return _movieName;
  }

  String? get director {
    return _director;
  }

  String? get imageCode {
    return _imageCode;
  }

  set movieName(String? movieName) {
    this._movieName = movieName;
  }

  set director(String? director) {
    this._director = director;
  }

  set imageCode(String? imageCode) {
    this._imageCode = imageCode;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['movieName'] = _movieName;
    map['director'] = _director;
    map['imageCode'] = _imageCode;
    return map;
  }

  Movie.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._movieName = map['movieName'];
    this._director = map['director'];
    this._imageCode = map['imageCode'];
  }
}
