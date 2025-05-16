import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class AuthController extends ChangeNotifier {
  final UserRepository _userRepository;
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  AuthController(this._userRepository);

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _userRepository.validateUser(email, password);
      if (success) {
        _currentUser = await _userRepository.getUserByEmail(email);
        _error = null;
      } else {
        _error = 'Email ou senha inválidos';
      }
      return success;
    } catch (e) {
      _error = 'Erro ao fazer login: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Verificar se o email já está em uso
      final existingUser = await _userRepository.getUserByEmail(email);
      if (existingUser != null) {
        _error = 'Este email já está em uso';
        return false;
      }

      final user = UserModel(
        name: name,
        email: email,
        password: password,
      );

      final createdUser = await _userRepository.createUser(user);
      if (createdUser != null) {
        _currentUser = createdUser;
        _error = null;
        return true;
      } else {
        _error = 'Erro ao criar usuário';
        return false;
      }
    } catch (e) {
      _error = 'Erro ao registrar: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(String name, String email) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedUser = UserModel(
        id: _currentUser!.id,
        name: name,
        email: email,
        password: _currentUser!.password,
        createdAt: _currentUser!.createdAt,
      );

      final success = await _userRepository.updateUser(updatedUser);
      if (success) {
        _currentUser = updatedUser;
        _error = null;
      } else {
        _error = 'Erro ao atualizar perfil';
      }
      return success;
    } catch (e) {
      _error = 'Erro ao atualizar perfil: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Verificar senha atual
      if (_currentUser!.password != currentPassword) {
        _error = 'Senha atual incorreta';
        return false;
      }

      final updatedUser = UserModel(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        password: newPassword,
        createdAt: _currentUser!.createdAt,
      );

      final success = await _userRepository.updateUser(updatedUser);
      if (success) {
        _currentUser = updatedUser;
        _error = null;
      } else {
        _error = 'Erro ao alterar senha';
      }
      return success;
    } catch (e) {
      _error = 'Erro ao alterar senha: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _currentUser = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
