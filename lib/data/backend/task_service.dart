import 'package:cloud_firestore/cloud_firestore.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createTask({
    required String userId,
    required DateTime scheduleDate,
    required String title,
    required String purpose,
    required DateTime startTime,
    required DateTime endTime,
    required String description,
    required DateTime reminder,
  }) async {
    final taskDoc = _firestore.collection('tasks').doc();

    await taskDoc.set({
      'userId': userId,
      'scheduleDate': scheduleDate,
      'title': title,
      'purpose': purpose,
      'startTime': startTime,
      'endTime': endTime,
      'description': description,
      'reminder': reminder,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
