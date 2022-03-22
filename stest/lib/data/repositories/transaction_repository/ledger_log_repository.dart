import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stest/data/models/transactions/ledger_log.dart';

class LedgerLogRepository {
  final _ledgerLog = FirebaseFirestore.instance.collection('ledgerlogs');

  Future<void> addLedgerLog({required LedgerLog log}) async {
    try {
      _ledgerLog.add(log.toDocument());
    } catch (e) {
      rethrow;
    }
  }

  //get the logs of a ledger by ledger id as list
  Stream<QuerySnapshot<Map<String, dynamic>>> getLedgerLog(
      {required String ledgerId}) {
    try {
      return _ledgerLog.where('ledgerId', isEqualTo: ledgerId).snapshots();
    } catch (e) {
      rethrow;
    }
  }
}
