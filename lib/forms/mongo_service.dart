import 'package:mongo_dart/mongo_dart.dart';

class MongoService {
  static Db? _db;

  static Future<Db> connect() async {
    if (_db == null) {
      _db = Db(
        'mongodb+srv://aureakimcyrus15:cyzimik123@agsecure.7a8dxqd.mongodb.net/agsecuredb',
      );
      await _db!.open();
    }
    return _db!;
  }

  static Future<List<Map<String, dynamic>>> getLessons() async {
    final db = await connect();
    final collection = db.collection('lessons'); // your collection
    final lessons = await collection.find().toList();
    return lessons;
  }

  static Future<void> addagescuredb(String s, String t) async {}
}
