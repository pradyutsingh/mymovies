import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  // const MovieCard({Key? key}) : super(key: key);
  final String? movieName;
  final String? imageData;
  final String? movieDirector;
  MovieCard({this.movieName, this.imageData, this.movieDirector});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(20.0), //or 15.0
              child: Container(
                height: 70.0,
                width: 70.0,
                color: Colors.white,
                child: Image.network(
                  'https://picsum.photos/250?image=9',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            title: Text('The Enchanted Nightingale'),
            subtitle: Text('Movie by Christopher Nolan'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
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
  }
}
