import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stest/data/models/ledgermodel/ledger.dart';
import 'package:stest/data/models/ledgermodel/ledger_entity.dart';

import 'package:stest/data/repositories/ledger_repository/base_ledger_repo.dart';

class LedgerRepository extends BaseLedgerRepository {
  final _ledgerCollection =
      FirebaseFirestore.instance.collection('activeledgers');
  @override
  Future<dynamic> addLedger(Ledger ledger) async {
    try {
      return await _ledgerCollection
          .doc(ledger.id)
          .set(ledger.toLedgerEntity().toDocument());
    } catch (e) {
      rethrow;
    }
  }

  //get all approved ledgers
  Stream<QuerySnapshot<Map<String, dynamic>>> ledgers() {
    return _ledgerCollection.snapshots();
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getLedgerByActiveStatus(
      {required bool isActive}) async {
    try {
      return await _ledgerCollection.where('isActive', isEqualTo: true).get();
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLedgerByMonth(
      {required int month, required int year}) {
    var start = DateTime.parse("$year-${(month < 10) ? '0' : ''}$month-01");
    var end = DateTime.parse("$year-${(month < 10) ? '0' : ''}$month-31");
    try {
      return _ledgerCollection
          .where('date', isGreaterThan: start)
          .where('date', isLessThan: end)
          .orderBy('date', descending: true)
          .snapshots();
    } catch (e) {
      rethrow;
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getLedgerById(
      {required String ledgerId}) {
    return _ledgerCollection.doc(ledgerId).snapshots();
  }

  Future<void> updatePayment(
      {required String ledgerId, required int value}) async {
    try {
      await _ledgerCollection.doc(ledgerId).update({'currentValue': value});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateStatus({required String ledgerId}) async {
    try {
      final snap = await _ledgerCollection.doc(ledgerId).get();
      Ledger ledger = Ledger.fromLedgerEntity(LedgerEntity.fromSnapShot(snap));
      if (ledger.currentValue == ledger.value) {
        await _ledgerCollection.doc(ledgerId).update({'isActive': false});
      }
    } catch (e) {
      rethrow;
    }
  }
}
