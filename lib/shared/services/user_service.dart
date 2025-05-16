import '../database/database_helper.dart';
import '../models/user_model.dart';

class UserService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> createUser(UserModel user) async {
    return await _dbHelper.insertUser(user.toMap());
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final userMap = await _dbHelper.getUserByEmail(email);
    if (userMap != null) {
      return UserModel.fromMap(userMap);
    }
    return null;
  }

  Future<List<UserModel>> getAllUsers() async {
    final List<Map<String, dynamic>> usersMap = await _dbHelper.getUsers();
    return List.generate(usersMap.length, (i) {
      return UserModel.fromMap(usersMap[i]);
    });
  }
} 