import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/backend/task_service.dart';

final taskServiceProvider = Provider<TaskService>((ref) => TaskService());

final userTasksProvider = FutureProvider.autoDispose<List<DocumentSnapshot>>((ref) async {
  final taskService = ref.read(taskServiceProvider);
  final userId = FirebaseAuth.instance.currentUser?.uid; // Replace with your own auth provider
  if (userId == null) {
    throw FirebaseAuthException(code: 'user-not-found', message: 'User not logged in');
  }
  return taskService.getUserTasks(userId);
});
