import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/student.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'student_management.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        address TEXT NOT NULL,
        dateOfBirth TEXT NOT NULL,
        gender TEXT NOT NULL,
        course TEXT NOT NULL,
        year TEXT NOT NULL,
        semester TEXT NOT NULL,
        profileImage TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertStudent(Student student) async {
    final db = await database;
    return await db.insert('students', student.toJson());
  }

  Future<List<Student>> getAllStudents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('students');
    return List.generate(maps.length, (i) => Student.fromJson(maps[i]));
  }

  Future<Student?> getStudentById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Student.fromJson(maps.first);
    }
    return null;
  }

  Future<int> updateStudent(Student student) async {
    final db = await database;
    return await db.update(
      'students',
      student.toJson(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future<int> deleteStudent(String id) async {
    final db = await database;
    return await db.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Student>> searchStudents(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'students',
      where: 'name LIKE ? OR email LIKE ? OR course LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) => Student.fromJson(maps[i]));
  }

  Future<List<Student>> getStudentsByCourse(String course) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'students',
      where: 'course = ?',
      whereArgs: [course],
    );
    return List.generate(maps.length, (i) => Student.fromJson(maps[i]));
  }

  Future<List<Student>> getStudentsByYear(String year) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'students',
      where: 'year = ?',
      whereArgs: [year],
    );
    return List.generate(maps.length, (i) => Student.fromJson(maps[i]));
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}