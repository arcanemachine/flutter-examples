import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:p05_weather_app/examples.dart';
// import 'package:p05_weather_app/models.dart';


Future main() async {
  // platform-specific boilerplate
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit(); // initialize FFI
  }
  databaseFactory = databaseFactoryFfi;

  // avoid errors caused by flutter upgrade
  WidgetsFlutterBinding.ensureInitialized();

  // get or create database
  final db = openDatabase(
    join(await getDatabasesPath(), 'db.sqlite3'),
    onCreate: (database, version) {
      return database.execute(
        'CREATE TABLE cities('
          'id INTEGER PRIMARY KEY,'
          'name TEXT,'
          'city_id TEXT'
        ')',
      );
    },
    version: 1,
  );

  if (kDebugMode) {
    runExamples(db);
  }
}