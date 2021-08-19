import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:mymovies_app/models/Movie.dart';

class DataBaseHelper {
  static DataBaseHelper? _dataBaseHelper;
  static Database? _database;

  String movieTable = 'movie_table';
  String colId = 'id';
  String colMovieName = 'movieName';
  String colDirector = 'director';
  String colImage = 'imageCode';

  DataBaseHelper._createInstance();

  factory DataBaseHelper() {
    if (_dataBaseHelper == null) {
      _dataBaseHelper = DataBaseHelper._createInstance();
    }
    return _dataBaseHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'movies1.db';

    var moviesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return moviesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
//     await db.execute(
//         'CREATE TABLE $movieTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colMovieName TEXT, '
// '$colDirector TEXT, $colImage TEXT)');

    await db.execute('''
create table $movieTable ( 
  $colId integer primary key autoincrement, 
  $colMovieName text not null,
  $colDirector text not null,
  $colImage text not null);
  ''');
  }

  // fetch all
  Future<List<Map<String, dynamic>>> getMovieMapList() async {
    Database db = await this.database;
    var result = await db.query(movieTable);
    return result;
  }

  Future<int> insertMovie(Movie movie) async {
    Database db = await this.database;
    var result = await db.insert(movieTable, movie.toMap());
    return result;
  }

  Future<int> updateMovie(Movie movie) async {
    var db = await this.database;
    var result = await db.update(movieTable, movie.toMap(),
        where: '$colId = ?', whereArgs: [movie.id]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $movieTable WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $movieTable');
    int result = Sqflite.firstIntValue(x)!;
    return result;
  }

  Future<List<Movie>> getMovieList() async {
    var movieMapList = await getMovieMapList();
    int count = movieMapList.length;

    List<Movie> movieList = [];
    for (int i = 0; i < count; i++) {
      movieList.add(Movie.fromMapObject(movieMapList[i]));
    }
    return movieList;
  }
}
