import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final scheduleDateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);
final startTimeProvider = StateProvider.autoDispose<DateTime?>((ref) => null);
final endTimeProvider = StateProvider.autoDispose<DateTime?>((ref) => null);
final priorityProvider = StateProvider.autoDispose<String?>((ref) => null);
// final purposeProvider = StateProvider.autoDispose<String?>((ref) => null);
final reminderProvider = StateProvider.autoDispose<DateTime?>((ref) => null);

// Define a provider for the selected purpose
final selectedPurposeProvider = ChangeNotifierProvider.autoDispose((ref) => SelectedPurposeNotifier());

// ChangeNotifier class to manage selected purpose
class SelectedPurposeNotifier extends ChangeNotifier {
  String? _selectedPurpose;

  String? get selectedPurpose => _selectedPurpose;

  set selectedPurpose(String? purpose) {
    _selectedPurpose = purpose;
    notifyListeners(); // Notify listeners of state change
  }
}
