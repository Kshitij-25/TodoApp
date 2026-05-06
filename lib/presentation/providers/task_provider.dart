import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/backend/authenticator.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';

final taskRepositoryProvider = Provider((ref) => TaskRepository());

final taskListProvider = StreamProvider<List<TaskModel>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  final userId = const Authenticator().userId;

  if (userId == null) {
    return Stream.value([]);
  }

  return repository.getTasks(userId);
});

final taskActionsProvider = Provider((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskActions(repository);
});

class TaskActions {
  TaskActions(this._repository);
  final TaskRepository _repository;

  Future<void> addTask(TaskModel task) => _repository.addTask(task);
  Future<void> updateTask(TaskModel task) => _repository.updateTask(task);
  Future<void> deleteTask(String taskId) => _repository.deleteTask(taskId);
  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) =>
      _repository.toggleTaskCompletion(taskId, isCompleted);
}
