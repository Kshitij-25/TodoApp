import 'package:hooks_riverpod/hooks_riverpod.dart';

final scheduleDateProvider = StateProvider<DateTime?>((ref) => null);
final startTimeProvider = StateProvider<DateTime?>((ref) => null);
final endTimeProvider = StateProvider<DateTime?>((ref) => null);
final priorityProvider = StateProvider<String?>((ref) => null);
final purposeProvider = StateProvider<String?>((ref) => null);
final reminderProvider = StateProvider<DateTime?>((ref) => null);
