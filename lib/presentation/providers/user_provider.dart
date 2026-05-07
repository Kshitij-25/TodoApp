import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tasktrackr/data/models/login_state.dart';
import 'package:tasktrackr/presentation/providers/auth_state_notifer.dart';

import '../../data/backend/authenticator.dart';
import '../../data/models/user_model.dart';

final userProfileProvider = StreamProvider<UserModel?>((ref) {
  final userId = const Authenticator().userId;
  final loginState = ref.watch(authStateNotifierProvider);

  if (userId == null || loginState != LoginState.success) {
    return Stream.value(null);
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .snapshots()
      .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
});
