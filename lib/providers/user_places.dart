import 'dart:io';

import 'package:favorite_places/model/place.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDataBase() async {
  final dbPath = await sql.getDatabasesPath();

  final db = await sql.openDatabase(path.join(dbPath, 'places.db'),
      onCreate: (db, version) => db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)'),
      version: 1);

  return db;
}

class UserPlacesNotifer extends StateNotifier<List<Place>> {
  UserPlacesNotifer() : super(const []);

  Future<void> loadPlace() async {
    final db = await _getDataBase();

    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String),
            placeLocation: PlaceLocation(
                latitude: row['lat'] as double,
                longitude: row['lng'] as double,
                address: row['address'] as String),
          ),
        )
        .toList();

    state = places;
  }

  void addPlace(String title, File image, PlaceLocation placelocation) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$fileName');

    final newPlace =
        Place(title: title, image: copiedImage, placeLocation: placelocation);

    //Sql Database Creation and insertion

    final db = await _getDataBase();
    db.insert(
      'places.db',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'lat': newPlace.placeLocation.latitude,
        'lng': newPlace.placeLocation.longitude,
        'address': newPlace.placeLocation.address
      },
    );

    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifer, List<Place>>(
  (ref) => UserPlacesNotifer(),
);
