import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../others/constants.dart';
import '../../models/transactions/due_insight.dart';

class DueRepository {
  final _dueRepository = FirebaseFirestore.instance.collection('dues');
  Future<void> updateDue(
      {required String from,
      required String to,
      required int value,
      required bool doIncrease}) async {
    try {
      final _querySnap = await _dueRepository
          .where('from', isEqualTo: to)
          .where('to', isEqualTo: from)
          .get();
      if (_querySnap.docs.isNotEmpty) {
        if (doIncrease) {
          final due = Due.fromQuerySnapShot(_querySnap.docs[0]);
          _dueRepository.doc(due.id).update({'due': due.due + value});
        } else {
          final due = Due.fromQuerySnapShot(_querySnap.docs[0]);
          _dueRepository.doc(due.id).update({'due': due.due - value});
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Due>> getDue() async {
    List<Due> dues = [];
    try {
      final snapshot = await _dueRepository
          .where('from', isEqualTo: Constants.user?.id)
          .get();
      for (int i = 0; i < snapshot.docs.length; i++) {
        dues.add(Due.fromQuerySnapShot(snapshot.docs[i]));
      }
    } catch (e) {
      rethrow;
    }

    return dues;
  }
}
