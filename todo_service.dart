import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveTodoList(List<Map<String, dynamic>> list) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = jsonEncode(list);
  await prefs.setString('todo_list', jsonString);
}

Future<List<Map<String, dynamic>>> loadTodoList() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('todo_list');
  if (jsonString != null) {
    final List decoded = jsonDecode(jsonString);
    return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
  } else {
    return [];
  }
}
