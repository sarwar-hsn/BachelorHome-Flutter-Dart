import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stest/data/models/usermodels/user.dart';
import 'package:stest/data/models/usermodels/user_entity.dart';
import 'package:stest/data/repositories/userrepo/baseruser_repository.dart';

class UserRepository extends BaseUserRepository {
  final _userCollection = FirebaseFirestore.instance.collection('users');

  //it will take a new instance of a user then to UserEntity then to toFirebase user (toDocument method)
  @override
  Future<void> updateUser(User user) async {
    return _userCollection
        .doc(user.id)
        .update(user.toUserEntity().toDocument());
  }

  //list of all users
  @override
  Stream<List<User>> users() {
    return _userCollection.snapshots().map((snapshots) {
      return snapshots.docs.map((doc) {
        final _user = User.fromUserEntity(UserEntity.fromSnapshot(doc));
        return _user;
      }).toList();
    });
  }

  //adding ledger to user's created array -  {used by requested ledger bloc}
  @override
  Future<void> addToCreatedLedger(
      {required String currentUserId, required String ledgerId}) async {
    final _userRef = _userCollection.doc(currentUserId);
    try {
      await _userRef.update({
        'createdLedgers': FieldValue.arrayUnion([ledgerId])
      });
    } catch (e) {
      rethrow;
    }
  }

  //adding ledger to assigned users pending array - {used by requested ledger bloc}
  Future<void> addToPending(String assignedToUserId, String ledgerId) async {
    final _userRef = _userCollection.doc(assignedToUserId);
    try {
      await _userRef.update({
        'pendingLedger': FieldValue.arrayUnion([ledgerId])
      });
    } catch (e) {
      rethrow;
    }
  }

  //if user approve then delete from pending array and add to assigned array -{used by main ledger bloc}
  @override
  Future<void> addToAssignedLedger(
      {required String assignedToUserId, required String ledgerId}) async {
    final _userRef = _userCollection.doc(assignedToUserId);
    try {
      await _userRef.update({
        'assignedLedgers': FieldValue.arrayUnion([ledgerId])
      });
    } catch (e) {
      rethrow;
    }
  }

  //should delete from pending array and add to declined array - {used by main ledger bloc}
  Future<void> addToDeclined(String assignedToUserId, String ledgerId) async {
    final _userRef = _userCollection.doc(assignedToUserId);
    try {
      await _userRef.update({
        'declinedLedgers': FieldValue.arrayUnion([ledgerId])
      });
    } catch (e) {
      rethrow;
    }
  }

  //getting as snap
  Stream<DocumentSnapshot<Map<String, dynamic>>> pendingLedgers(
      {required String userId}) {
    try {
      final _userRef = _userCollection.doc(userId);

      return _userRef.snapshots();
    } catch (e) {
      rethrow;
    }
  }

  //remove from pending ledger
  Future<void> deleteFromPending(String userId, String ledgerId) async {
    final docRef = _userCollection.doc(userId);
    try {
      await docRef.update({
        'pendingLedger': FieldValue.arrayRemove([ledgerId])
      });
    } catch (e) {
      rethrow;
    }
  }
}
