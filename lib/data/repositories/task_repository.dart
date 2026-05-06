import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task_model.dart';

class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'tasks';

  Stream<List<TaskModel>> getTasks(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('dueDate', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map(TaskModel.fromFirestore).toList();
    });
  }

  Future<void> addTask(TaskModel task) {
    return _firestore.collection(_collection).add(task.toFirestore());
  }

  Future<void> updateTask(TaskModel task) {
    return _firestore
        .collection(_collection)
        .doc(task.id)
        .update(task.toFirestore());
  }

  Future<void> deleteTask(String taskId) {
    return _firestore.collection(_collection).doc(taskId).delete();
  }

  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) {
    return _firestore.collection(_collection).doc(taskId).update({
      'isCompleted': isCompleted,
    });
  }

  Future<void> rollOverTasks(String userId) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final snapshot = await _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('isCompleted', isEqualTo: false)
        .where('dueDate', isLessThan: today)
        .get();

    for (var doc in snapshot.docs) {
      final task = TaskModel.fromFirestore(doc);
      final newDueDate = DateTime(now.year, now.month, now.day + 1,
          task.dueDate.hour, task.dueDate.minute);
      await updateTask(task.copyWith(dueDate: newDueDate));
    }
  }
}
