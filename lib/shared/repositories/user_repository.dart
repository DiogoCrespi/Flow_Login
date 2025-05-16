import '../database/database_helper.dart';
import '../models/user_model.dart';

class UserRepository {
  final DatabaseHelper _dbHelper;

  UserRepository(this._dbHelper);

  Future<UserModel?> createUser(UserModel user) async {
    try {
      final id = await _dbHelper.insertUser(user.toMap());
      return id > 0 ? user : null;
    } catch (e) {
      print('Erro ao criar usuário: $e');
      return null;
    }
  }

  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final userMap = await _dbHelper.getUserByEmail(email);
      return userMap != null ? UserModel.fromMap(userMap) : null;
    } catch (e) {
      print('Erro ao buscar usuário: $e');
      return null;
    }
  }

  Future<bool> validateUser(String email, String password) async {
    try {
      final user = await getUserByEmail(email);
      return user != null && user.password == password;
    } catch (e) {
      print('Erro ao validar usuário: $e');
      return false;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final users = await _dbHelper.getUsers();
      return users.map((map) => UserModel.fromMap(map)).toList();
    } catch (e) {
      print('Erro ao buscar todos os usuários: $e');
      return [];
    }
  }

  Future<bool> updateUser(UserModel user) async {
    try {
      final result = await _dbHelper.updateUser(user.toMap());
      return result > 0;
    } catch (e) {
      print('Erro ao atualizar usuário: $e');
      return false;
    }
  }

  Future<bool> deleteUser(int id) async {
    try {
      final result = await _dbHelper.deleteUser(id);
      return result > 0;
    } catch (e) {
      print('Erro ao deletar usuário: $e');
      return false;
    }
  }
}
