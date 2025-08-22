import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String _username = '';
  String _role = 'admin';

  bool get isAuthenticated => _isAuthenticated;
  String get username => _username;
  String get role => _role;

  AuthProvider() {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
      _username = prefs.getString('username') ?? '';
      _role = prefs.getString('role') ?? 'admin';
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading auth state: $e');
    }
  }

  Future<void> login(String username, String password) async {
    // Simple authentication for demo purposes
    // In a real app, you would implement proper authentication
    if (username.isNotEmpty && password.isNotEmpty) {
      _isAuthenticated = true;
      _username = username;
      _role = username == 'admin' ? 'admin' : 'user';
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('username', username);
      await prefs.setString('role', _role);
      
      notifyListeners();
    } else {
      throw Exception('Invalid credentials');
    }
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _username = '';
    _role = 'admin';
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);
    await prefs.setString('username', '');
    await prefs.setString('role', 'admin');
    
    notifyListeners();
  }

  bool hasPermission(String permission) {
    if (_role == 'admin') return true;
    
    switch (permission) {
      case 'view_students':
        return true;
      case 'add_students':
        return _role == 'admin';
      case 'edit_students':
        return _role == 'admin';
      case 'delete_students':
        return _role == 'admin';
      default:
        return false;
    }
  }
}