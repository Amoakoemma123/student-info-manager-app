import 'package:flutter/foundation.dart';
import '../models/student.dart';
import '../services/database_helper.dart';
import 'package:uuid/uuid.dart';

class StudentProvider with ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final Uuid _uuid = const Uuid();
  
  List<Student> _students = [];
  List<Student> _filteredStudents = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _filterCourse = '';
  String _filterYear = '';

  List<Student> get students => _students;
  List<Student> get filteredStudents => _filteredStudents;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get filterCourse => _filterCourse;
  String get filterYear => _filterYear;

  Future<void> loadStudents() async {
    _isLoading = true;
    notifyListeners();

    try {
      _students = await _databaseHelper.getAllStudents();
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading students: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addStudent(Student student) async {
    try {
      final newStudent = student.copyWith(
        id: _uuid.v4(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await _databaseHelper.insertStudent(newStudent);
      _students.add(newStudent);
      _applyFilters();
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding student: $e');
      rethrow;
    }
  }

  Future<void> updateStudent(Student student) async {
    try {
      final updatedStudent = student.copyWith(updatedAt: DateTime.now());
      await _databaseHelper.updateStudent(updatedStudent);
      
      final index = _students.indexWhere((s) => s.id == student.id);
      if (index != -1) {
        _students[index] = updatedStudent;
        _applyFilters();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating student: $e');
      rethrow;
    }
  }

  Future<void> deleteStudent(String id) async {
    try {
      await _databaseHelper.deleteStudent(id);
      _students.removeWhere((student) => student.id == id);
      _applyFilters();
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting student: $e');
      rethrow;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void setFilterCourse(String course) {
    _filterCourse = course;
    _applyFilters();
    notifyListeners();
  }

  void setFilterYear(String year) {
    _filterYear = year;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _filterCourse = '';
    _filterYear = '';
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredStudents = _students.where((student) {
      bool matchesSearch = _searchQuery.isEmpty ||
          student.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          student.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          student.course.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesCourse = _filterCourse.isEmpty || student.course == _filterCourse;
      bool matchesYear = _filterYear.isEmpty || student.year == _filterYear;

      return matchesSearch && matchesCourse && matchesYear;
    }).toList();
  }

  List<String> get uniqueCourses {
    return _students.map((student) => student.course).toSet().toList()..sort();
  }

  List<String> get uniqueYears {
    return _students.map((student) => student.year).toSet().toList()..sort();
  }

  int get totalStudents => _students.length;
  int get filteredStudentsCount => _filteredStudents.length;

  Student? getStudentById(String id) {
    try {
      return _students.firstWhere((student) => student.id == id);
    } catch (e) {
      return null;
    }
  }
}