import 'package:flutter/material.dart';
import 'jalali_util.dart';

class TodoCard extends StatelessWidget {
  final Map<String, dynamic> task;
  final Duration remaining;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final bool isDarkMode;

  const TodoCard({
    required this.task,
    required this.remaining,
    required this.onDelete,
    required this.onTap,
    required this.isDarkMode,
  });

  String _formatDuration(Duration duration) {
    return '${duration.inDays} روز، ${duration.inHours % 24} ساعت، ${duration.inMinutes % 60} دقیقه، ${duration.inSeconds % 60} ثانیه';
  }

  @override
  Widget build(BuildContext context) {
    final deadline = DateTime.parse(task['deadline']);
    return Dismissible(
      key: Key(task['task']),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Card(
        color: Color(task['color']).withOpacity(0.7),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        child: ListTile(
          title: Text(
            task['task'],
            style: TextStyle(
              fontSize: 18,
              color: isDarkMode ? Colors.white : Colors.black,
              decoration:
                  task['isCompleted'] ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            'زمان باقی‌مانده: ${_formatDuration(remaining)}\nتاریخ: ${toJalaliString(deadline)}',
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
