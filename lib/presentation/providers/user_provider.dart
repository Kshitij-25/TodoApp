import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/backend/authenticator.dart';
import '../../data/models/user_model.dart';

final userProfileProvider = StreamProvider<UserModel?>((ref) {
  final userId = const Authenticator().userId;
  if (userId == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .snapshots()
      .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
});
