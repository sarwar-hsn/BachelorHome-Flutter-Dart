import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stest/data/models/ledgermodel/ledger.dart';

abstract class BaseLedgerRepository {
  Future<void> addLedger(Ledger ledger);
  Future<QuerySnapshot<Map<String, dynamic>>> getLedgerByActiveStatus(
      {required bool isActive});
}
