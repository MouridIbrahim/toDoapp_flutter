import 'package:flutter/material.dart';

/// Utility functions for date handling
class DateUtils {
  DateUtils._();

  /// Format DateTime to string in YYYY-MM-DD format
  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Parse string to DateTime
  static DateTime? parseDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Get color based on due date
  static Color getDueDateColor(String? dueDate) {
    if (dueDate == null || dueDate.isEmpty) return Colors.grey;

    try {
      final taskDate = DateTime.parse(dueDate);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      if (taskDate == today) {
        return Colors.red; // Due Today
      } else if (taskDate == tomorrow) {
        return Colors.orange; // Due Tomorrow
      } else if (taskDate.isBefore(today)) {
        return Colors.grey.shade700; // Past due date
      } else {
        return Colors.grey; // Future dates
      }
    } catch (e) {
      return Colors.grey;
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// Format date for display
  static String formatDisplayDate(String? dueDate) {
    if (dueDate == null || dueDate.isEmpty) return 'No date set';

    try {
      final date = DateTime.parse(dueDate);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dueDate;
    }
  }
}

/// Utility functions for validation
class ValidationUtils {
  ValidationUtils._();

  /// Validate task title
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title is required';
    }
    if (value.length > 100) {
      return 'Title must be less than 100 characters';
    }
    return null;
  }

  /// Validate task description
  static String? validateDescription(String? value) {
    if (value != null && value.length > 500) {
      return 'Description must be less than 500 characters';
    }
    return null;
  }

  /// Validate category selection
  static String? validateCategory(String? category) {
    if (category == null || category.isEmpty || category == 'None') {
      return 'Please select a category';
    }
    return null;
  }
}

/// String utility extensions
extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  bool isValidDate() {
    try {
      DateTime.parse(this);
      return true;
    } catch (e) {
      return false;
    }
  }
}
