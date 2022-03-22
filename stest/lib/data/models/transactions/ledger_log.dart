import 'package:cloud_firestore/cloud_firestore.dart';

class LedgerLog {
  final String ledgerId;
  final DateTime date;
  final int value;
  const LedgerLog(
      {required this.ledgerId, required this.date, required this.value});

  Map<String, Object> toDocument() {
    return {'ledgerId': ledgerId, 'date': date, 'value': value};
  }

  static LedgerLog fromDocumentSnapShot(DocumentSnapshot snap) {
    return LedgerLog(
        ledgerId: (snap.data() as dynamic)['ledgerId'],
        date: (snap.data() as dynamic)['date'].toDate(),
        value: (snap.data() as dynamic)['value'].toInt());
  }

  static LedgerLog fromQuerySnapShot(QueryDocumentSnapshot snap) {
    return LedgerLog(
        ledgerId: (snap.data() as dynamic)['ledgerId'],
        date: (snap.data() as dynamic)['date'].toDate(),
        value: (snap.data() as dynamic)['value'].toInt());
  }

  @override
  String toString() {
    return 'ledger log -ledgerId:$ledgerId date: ${date.toIso8601String()} value: $value';
  }
}
