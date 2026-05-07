import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/backend/authenticator.dart';
import 'task_provider.dart';

final syncStatusProvider = StreamProvider<bool>((ref) {
  final userId = const Authenticator().userId;
  if (userId == null) return Stream.value(false);

  final repository = ref.watch(taskRepositoryProvider);
  return repository.getSyncStatus(userId);
});
