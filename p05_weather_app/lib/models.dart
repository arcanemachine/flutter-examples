class City {
  final int id;
  final String name;
  final String cityId;

  const City({
    required this.id,
    required this.name,
    required this.cityId,
  });

  // convert a City into a Map. the keys must correspond to the names
  // of the columns in the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'city_id': cityId,
    };
  }

  // implement toString to make it easier to see information about each
  // city when using the print statement
  @override
  String toString() {
    return 'City{id: $id, name: $name, cityId: $cityId}';
  }
}