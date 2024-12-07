import 'package:news_app/views/home_view.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';


class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  // Get database instance (creates if not already created)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('news.db');
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3, // Incremented version number
      onCreate: _createDB,
    );
  }

  // Create the database schema (for version 1)

   Future _createDB(Database db, int version) async {
    await db.execute('''CREATE TABLE articles (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      url TEXT,
      description TEXT,
      content TEXT,
      author TEXT,
      publishedAt TEXT,
      urlToImage TEXT)''');
  }


  // Insert a new note into the database
  Future<int> insertArticles(Map<String, dynamic> articles) async {
    final db = await instance.database;
   return await db.insert('articles', articles);

  }


  // Get all Articles
  Future<List<Article>> getArticles({bool? archived}) async {
    final db = await instance.database;
   final data =  await db.query('articles');
   List<Article> news = data
        .map((val) => Article(
            id: val["id"] as int,
            title: val["title"] as String,
            url: "test",
            description: val["description"] as String,
            content: val["content"] as String,
            author: val["author"] as String,
            publishedAt: "test",
            urlToImage: "test",

            ))
        .toList();
    return news;
  }

Future<void> deleteArticle(int id) async {
  final db = await instance.database;
   await db.delete(
    'articles',
    where: 'id = ?',
    whereArgs: [id],
  );
}

}
