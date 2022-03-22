import 'package:cloud_firestore/cloud_firestore.dart';

class Due {
  String id;
  final String from;
  final String to;
  final int due;
  Due(
      {required this.due,
      required this.id,
      required this.from,
      required this.to});

  Map<String, Object> toDocument() {
    return {
      'from': from,
      'to': to,
      'due': 0,
    };
  }

  static Due fromDocumentSnapShot(DocumentSnapshot snap) {
    return Due(
        id: snap.id,
        from: (snap.data() as dynamic)['from'],
        to: (snap.data() as dynamic)['to'],
        due: (snap.data() as dynamic)['due'].toInt());
  }

  static Due fromQuerySnapShot(QueryDocumentSnapshot snap) {
    return Due(
        id: snap.id,
        from: (snap.data() as dynamic)['from'],
        to: (snap.data() as dynamic)['to'],
        due: (snap.data() as dynamic)['due'].toInt());
  }

  @override
  String toString() {
    return '[ Due - creator: $from assignedTo: $to value: $due]';
  }
}
