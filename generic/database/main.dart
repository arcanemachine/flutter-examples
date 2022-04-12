import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// import 'package:p05_weather_app/city.dart';
import 'package:p05_weather_app/models.dart';


Future main() async {
  if (Platform.isWindows || Platform.isLinux) {
    // initialize FFI
    sqfliteFfiInit();
  }

  databaseFactory = databaseFactoryFfi;

  // avoid errors caused by flutter upgrade
  WidgetsFlutterBinding.ensureInitialized();

  // create db
  final database = openDatabase(
    join(await getDatabasesPath(), 'db.sqlite3'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE cities('
          'id INTEGER PRIMARY KEY,'
          'name TEXT,'
          'city_id TEXT'
        ')',
      );
    },
    version: 1,
  );

  // method: insert into db
  Future<void> insertCity(City city) async {
    final db = await database;

    await db.insert(
      'cities',
      city.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // method: read from db
  Future<List<City>> cities() async {
    final db = await database;

    // query the table for all cities
    final List<Map<String, dynamic>> maps = await db.query('cities');

    // convert the List<Map<String>> into a List<City>
    return List.generate(maps.length, (i) => City(
      id: maps[i]['id'],
      name: maps[i]['name'],
      cityId: maps[i]['city_id'],
    ));
  }

  // example: create and read city
  var edmonton = const City(
    id: 0,
    name: "Edmonton",
    cityId: 'abc',
  );
  await insertCity(edmonton);
  if (kDebugMode) print(await cities());

  // method: update the db
  Future<void> updateCity(City city) async {
    final db = await database;

    await db.update(
      'cities',
      city.toMap(),
      where: 'id = ?',
      whereArgs: [city.id],
    );
  }

  // example: update city
  var edmonton2 = const City(
    id: 0,
    name: "Edmonton",
    cityId: 'def',
  );
  updateCity(edmonton2);

  if (kDebugMode) print(await cities());

  // method: delete city
  Future<void> deleteCity(int id) async {
    final db = await database;

    await db.delete(
      'cities',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // example: delete city
  if (kDebugMode) print(await cities());
}
