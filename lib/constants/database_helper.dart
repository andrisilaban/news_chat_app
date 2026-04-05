import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:news_chat_app/features/chat/models/chat_message.dart';
import 'package:news_chat_app/features/headline_news/models/headline_news_response_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'news_chat.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // User Profile Table
    await db.execute('''
      CREATE TABLE user_profile (
        uid TEXT PRIMARY KEY,
        email TEXT,
        displayName TEXT,
        photoUrl TEXT
      )
    ''');

    // Cached News Table
    await db.execute('''
      CREATE TABLE cached_news (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT,
        author TEXT,
        title TEXT,
        description TEXT,
        url TEXT,
        urlToImage TEXT,
        publishedAt TEXT,
        content TEXT,
        source_name TEXT
      )
    ''');

    // Chat History Table
    await db.execute('''
      CREATE TABLE chat_history (
        id TEXT PRIMARY KEY,
        text TEXT,
        imagePath TEXT,
        isUser INTEGER,
        timestamp TEXT
      )
    ''');

    // Bookmarks Table
    await db.execute('''
      CREATE TABLE bookmarks (
        url TEXT PRIMARY KEY,
        category TEXT,
        author TEXT,
        title TEXT,
        description TEXT,
        urlToImage TEXT,
        publishedAt TEXT,
        content TEXT,
        source_name TEXT
      )
    ''');
  }

  // ==== USER PROFILE ====
  Future<void> saveUser(Map<String, dynamic> userMap) async {
    final db = await database;
    await db.insert(
      'user_profile',
      userMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUser() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user_profile', limit: 1);
    if (maps.isNotEmpty) return maps.first;
    return null;
  }

  Future<void> clearUser() async {
    final db = await database;
    await db.delete('user_profile');
  }

  // ==== CACHED NEWS ====
  Future<void> cacheNews(String category, List<Article> articles) async {
    final db = await database;
    await db.transaction((txn) async {
      // Clear old cache for this category
      await txn.delete('cached_news', where: 'category = ?', whereArgs: [category]);
      
      // Insert new
      for (var article in articles) {
        await txn.insert('cached_news', {
          'category': category,
          'author': article.author,
          'title': article.title,
          'description': article.description,
          'url': article.url,
          'urlToImage': article.urlToImage,
          'publishedAt': article.publishedAt,
          'content': article.content,
          'source_name': article.source?.name,
        });
      }
    });
  }

  Future<List<Article>> getCachedNews(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cached_news',
      where: 'category = ?',
      whereArgs: [category],
    );

    return List.generate(maps.length, (i) {
      return Article(
        author: maps[i]['author'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        url: maps[i]['url'],
        urlToImage: maps[i]['urlToImage'],
        publishedAt: maps[i]['publishedAt'],
        content: maps[i]['content'],
        source: maps[i]['source_name'] != null ? Source(name: maps[i]['source_name']) : null,
      );
    });
  }

  // ==== CHAT HISTORY ====
  Future<void> insertChatMessage(ChatMessage message) async {
    final db = await database;
    await db.insert(
      'chat_history',
      {
        'id': message.id,
        'text': message.text,
        'imagePath': message.imagePath,
        'isUser': message.isUser ? 1 : 0,
        'timestamp': message.timestamp.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ChatMessage>> getChatMessages() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('chat_history', orderBy: 'timestamp ASC');

    return List.generate(maps.length, (i) {
      return ChatMessage(
        id: maps[i]['id'] as String,
        text: maps[i]['text'] as String?,
        imagePath: maps[i]['imagePath'] as String?,
        isUser: (maps[i]['isUser'] as int) == 1,
        timestamp: DateTime.parse(maps[i]['timestamp'] as String),
      );
    });
  }

  // ==== BOOKMARKS ====
  Future<void> insertBookmark(String category, Article article) async {
    final db = await database;
    await db.insert(
      'bookmarks',
      {
        'url': article.url,
        'category': category,
        'author': article.author,
        'title': article.title,
        'description': article.description,
        'urlToImage': article.urlToImage,
        'publishedAt': article.publishedAt,
        'content': article.content,
        'source_name': article.source?.name,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteBookmark(String url) async {
    final db = await database;
    await db.delete('bookmarks', where: 'url = ?', whereArgs: [url]);
  }

  Future<List<Map<String, dynamic>>> getBookmarks() async {
    final db = await database;
    return await db.query('bookmarks', orderBy: 'publishedAt DESC');
  }

  Future<bool> isBookmarked(String url) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'bookmarks',
      where: 'url = ?',
      whereArgs: [url],
    );
    return result.isNotEmpty;
  }
}
