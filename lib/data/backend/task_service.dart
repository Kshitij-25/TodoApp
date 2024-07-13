import 'package:cloud_firestore/cloud_firestore.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createTask({
    required String userId,
    required String scheduleDate,
    required String title,
    required String purpose,
    required String startTime,
    required String endTime,
    required String description,
    required String reminder,
    required String priority,
    required String taskStatus,
  }) async {
    try {
      // Get a reference to the user's document
      final userDocRef = _firestore.collection('users').doc(userId);

      // Generate a new task document ID
      final taskDocRef = userDocRef.collection('tasks').doc();
      final taskId = taskDocRef.id;

      // Set data for the task document
      await taskDocRef.set({
        'taskId': taskId,
        'userId': userId,
        'scheduleDate': scheduleDate,
        'title': title,
        'purpose': purpose,
        'startTime': startTime,
        'endTime': endTime,
        'description': description,
        'reminder': reminder,
        'priority': priority,
        'taskStatus': taskStatus,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Optional: Update user's last activity or task count, etc., in the user document
    } catch (e) {
      // Handle any errors here
      throw 'Failed to create task: $e';
    }
  }

  Future<List<DocumentSnapshot>> getUserTasks(String userId) async {
    try {
      final querySnapshot = await _firestore.collection('users').doc(userId).collection('tasks').get();

      return querySnapshot.docs;
    } catch (e) {
      print('Error retrieving user tasks: $e');
      rethrow;
    }
  }

  Future<void> editTask({
    required String userId,
    required String taskId,
    String? scheduleDate,
    String? title,
    String? purpose,
    String? startTime,
    String? endTime,
    String? description,
    String? reminder,
    String? priority,
    String? taskStatus,
  }) async {
    try {
      // Get a reference to the user's task document
      final taskDocRef = _firestore.collection('users').doc(userId).collection('tasks').doc(taskId);

      // Create a map of the fields to update
      Map<String, dynamic> updates = {};
      if (scheduleDate != null) updates['scheduleDate'] = scheduleDate;
      if (title != null) updates['title'] = title;
      if (purpose != null) updates['purpose'] = purpose;
      if (startTime != null) updates['startTime'] = startTime;
      if (endTime != null) updates['endTime'] = endTime;
      if (description != null) updates['description'] = description;
      if (reminder != null) updates['reminder'] = reminder;
      if (priority != null) updates['priority'] = priority;
      if (taskStatus != null) updates['taskStatus'] = taskStatus;

      // Update the task document
      await taskDocRef.update(updates);
    } catch (e) {
      // Handle any errors here
      throw 'Failed to edit task: $e';
    }
  }

  Future<void> updateTaskCompletionStatus({
    required String userId,
    required String taskId,
    required String taskStatus,
  }) async {
    try {
      // Get a reference to the user's task document
      final taskDocRef = _firestore.collection('users').doc(userId).collection('tasks').doc(taskId);

      // Update the isCompleted field
      await taskDocRef.update({'taskStatus': taskStatus});
    } catch (e) {
      // Handle any errors here
      throw 'Failed to update task completion status: $e';
    }
  }

  Future<void> deleteTask({
    required String userId,
    required String taskId,
  }) async {
    try {
      // Get a reference to the user's task document
      final taskDocRef = _firestore.collection('users').doc(userId).collection('tasks').doc(taskId);

      // Delete the task document
      await taskDocRef.delete();
    } catch (e) {
      // Handle any errors here
      throw 'Failed to delete task: $e';
    }
  }
}
