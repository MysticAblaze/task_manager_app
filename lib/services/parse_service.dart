import 'package:parse_server_sdk/parse_server_sdk.dart';

class ParseService {
  // AUTH
  static Future<ParseResponse> register(String email, String password) async {
    final user = ParseUser(email, password, email);
    return await user.signUp();
  }

  static Future<ParseResponse> login(String email, String password) async {
    final user = ParseUser(email, password, null);
    return await user.login();
  }

  static Future<void> logout() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    await user?.logout();
  }

  // TASKS
  static Future<List<ParseObject>> getTasks() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    final query = QueryBuilder<ParseObject>(ParseObject('Task'))
      ..whereEqualTo('owner', user)
      ..orderByDescending('createdAt');
    final response = await query.query();
    return response.success && response.results != null
        ? response.results as List<ParseObject>
        : [];
  }

  static Future<bool> createTask(String title, String description) async {
    final user = await ParseUser.currentUser() as ParseUser?;
    final task = ParseObject('Task')
      ..set('title', title)
      ..set('description', description)
      ..set('isDone', false)
      ..set('owner', user);
    final response = await task.save();
    return response.success;
  }

  static Future<bool> updateTask(
      String objectId, String title, String description, bool isDone) async {
    final task = ParseObject('Task')..objectId = objectId;
    task
      ..set('title', title)
      ..set('description', description)
      ..set('isDone', isDone);
    final response = await task.save();
    return response.success;
  }

  static Future<bool> deleteTask(String objectId) async {
    final task = ParseObject('Task')..objectId = objectId;
    final response = await task.delete();
    return response.success;
  }
}