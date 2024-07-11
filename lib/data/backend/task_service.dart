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
  }) async {
    try {
      // Get a reference to the user's document
      final userDocRef = _firestore.collection('users').doc(userId);

      // Create a new task document inside the tasks subcollection
      final taskDocRef = userDocRef.collection('tasks').doc();

      // Set data for the task document
      await taskDocRef.set({
        'userId': userId,
        'scheduleDate': scheduleDate,
        'title': title,
        'purpose': purpose,
        'startTime': startTime,
        'endTime': endTime,
        'description': description,
        'reminder': reminder,
        'priority': priority,
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
}
