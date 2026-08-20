import 'package:flutter/material.dart';

/// Reusable task card widget
class TaskCard extends StatelessWidget {
  final String title;
  final String? dueDate;
  final bool isCompleted;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onCheckboxChanged;
  final VoidCallback? onDeletePressed;

  const TaskCard({
    super.key,
    required this.title,
    this.dueDate,
    this.isCompleted = false,
    this.onTap,
    this.onCheckboxChanged,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 2,
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onTap,
        child: Row(
          children: [
            Checkbox(
              value: isCompleted,
              onChanged: onCheckboxChanged,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  if (dueDate != null && dueDate!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      _formatDueDate(dueDate!),
                      style: TextStyle(
                        fontSize: 13,
                        color: _getDueDateColor(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (onDeletePressed != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDeletePressed,
              ),
          ],
        ),
      ),
    );
  }

  Color _getDueDateColor() {
    try {
      final taskDate = DateTime.parse(dueDate!);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      if (taskDate == today) {
        return Colors.red;
      } else if (taskDate == tomorrow) {
        return Colors.orange;
      } else if (taskDate.isBefore(today)) {
        return Colors.grey.shade700;
      } else {
        return Colors.grey;
      }
    } catch (e) {
      return Colors.grey;
    }
  }

  String _formatDueDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return '${parsed.day.toString().padLeft(2, '0')}/${parsed.month.toString().padLeft(2, '0')}/${parsed.year}';
    } catch (e) {
      return date;
    }
  }
}
