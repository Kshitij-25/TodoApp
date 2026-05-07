import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.priority,
    required this.category,
    this.isCompleted = false,
    required this.userId,
    this.isPending = false,
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'],
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      priority: data['priority'] ?? 'Low',
      category: data['category'] ?? 'General',
      isCompleted: data['isCompleted'] ?? false,
      userId: data['userId'] ?? '',
      isPending: doc.metadata.hasPendingWrites,
    );
  }
  final String id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final String priority;
  final String category;
  final bool isCompleted;
  final String userId;
  final bool isPending;

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'priority': priority,
      'category': category,
      'isCompleted': isCompleted,
      'userId': userId,
    };
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? priority,
    String? category,
    bool? isCompleted,
    String? userId,
    bool? isPending,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
      isPending: isPending ?? this.isPending,
    );
  }
}
