import 'package:flutter/material.dart';
import 'dart:async';
import 'todo_service.dart';
import 'jalali_util.dart';
import 'todo_card.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Map<String, dynamic>> _todoList = [];
  final TextEditingController _textController = TextEditingController();
  bool _isDarkMode = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadTodoList();
    _timer = Timer.periodic(Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _sortTasks() {
    _todoList.sort((a, b) {
      final deadlineA = DateTime.parse(a['deadline']);
      final deadlineB = DateTime.parse(b['deadline']);
      return deadlineA.compareTo(deadlineB);
    });
  }

  void _addTodoItem(String task, DateTime deadline, Color color) {
    if (task.isNotEmpty) {
      setState(() {
        _todoList.add({
          'task': task,
          'deadline': deadline.toIso8601String(),
          'isCompleted': false,
          'color': color.value,
        });
        _sortTasks();
        saveTodoList(_todoList);
      });
      _textController.clear();
    }
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todoList.removeAt(index);
      saveTodoList(_todoList);
    });
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  Future<void> _loadTodoList() async {
    final list = await loadTodoList();
    setState(() {
      _todoList = list;
    });
  }

  void _openDesignerWebsite() {
    final url = 'http://i_mhp_i.rzb.ir';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('لینک طراح برنامه: $url')),
    );
  }

  void _showJalaliDateTimePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        final DateTime deadline = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        final Color? pickedColor = await showDialog<Color>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('انتخاب رنگ'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  _buildColorOption(Colors.red),
                  _buildColorOption(Colors.blue),
                  _buildColorOption(Colors.green),
                  _buildColorOption(Colors.orange),
                  _buildColorOption(Colors.purple),
                  _buildColorOption(Colors.teal),
                ],
              ),
            ),
          ),
        );
        if (pickedColor != null) {
          _addTodoItem(_textController.text, deadline, pickedColor);
        }
      }
    }
  }

  Widget _buildColorOption(Color color) {
    return ListTile(
      leading: Container(width: 30, height: 30, color: color),
      title: Text(color.toString().split('(')[1].split(')')[0]),
      onTap: () => Navigator.pop(context, color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        actions: [
          IconButton(
            icon: Icon(Icons.design_services),
            onPressed: _openDesignerWebsite,
          ),
          Switch(
            value: _isDarkMode,
            onChanged: _toggleDarkMode,
            activeColor: Colors.blue,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isDarkMode
                ? [Colors.grey[900]!, Colors.grey[800]!]
                : [Colors.blue[100]!, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'وظیفه جدید وارد کنید',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor:
                          _isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _showJalaliDateTimePicker(context),
                    child: Text('تعیین زمان و رنگ'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _todoList.isEmpty
                  ? Center(child: Text('هنوز وظیفه‌ای ثبت نشده!'))
                  : ListView.builder(
                      itemCount: _todoList.length,
                      itemBuilder: (context, index) {
                        final task = _todoList[index];
                        final deadline = DateTime.parse(task['deadline']);
                        final remaining =
                            deadline.difference(DateTime.now());
                        return TodoCard(
                          task: task,
                          remaining: remaining,
                          onDelete: () => _removeTodoItem(index),
                          onTap: () {
                            setState(() {
                              task['isCompleted'] = !task['isCompleted'];
                              saveTodoList(_todoList);
                            });
                          },
                          isDarkMode: _isDarkMode,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
