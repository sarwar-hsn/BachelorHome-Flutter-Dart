import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stest/data/models/ledgermodel/ledger.dart';
import 'package:stest/data/models/ledgermodel/ledger_entity.dart';

class RequestedLedgerRepository {
  final _ledgerCollection =
      FirebaseFirestore.instance.collection('requestedLedger');

  Future<dynamic> addLedger(Ledger ledger) async {
    try {
      return await _ledgerCollection.add(ledger.toLedgerEntity().toDocument());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Ledger>> requestedLedgers() {
    return _ledgerCollection.snapshots().map((snapshots) {
      return snapshots.docs.map((doc) {
        final _ledger = Ledger.fromLedgerEntity(LedgerEntity.fromSnapShot(doc));
        return _ledger;
      }).toList();
    });
  }

  Future<Ledger> removeLedger({required String ledgerId}) async {
    try {
      final snap = await _ledgerCollection.doc(ledgerId).get();
      Ledger ledger = Ledger.fromLedgerEntity(LedgerEntity.fromSnapShot(snap));
      _ledgerCollection.doc(ledgerId).delete();
      return ledger;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Ledger>> pendingLedgers(List<String> ledgerIds) async {
    final List<Ledger> pendingLedgers = [];
    try {
      for (int i = 0; i < ledgerIds.length; i++) {
        final tempLedger = await _ledgerCollection.doc(ledgerIds[i]).get();

        pendingLedgers.add(
            Ledger.fromLedgerEntity(LedgerEntity.fromSnapShot(tempLedger)));
      }
      return pendingLedgers;
    } catch (e) {
      rethrow;
    }
  }
}
