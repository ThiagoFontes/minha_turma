import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

mixin FirestoreMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> getTodos() {
    final doc =
        _firestore.collection('active').doc(_userId).collection('todos');

    return doc;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTodosStream({
    bool done = false,
    int limit = 10,
    int offset = 0,
  }) {
    final pending = getTodos();
    limit = limit == 0 ? 10 : limit;

    final viewMore = offset == 0;

    final stream = pending
        .orderBy('index')
        .orderBy('date', descending: false)
        .where('done', isEqualTo: done)
        .startAt([offset])
        .limit(viewMore ? (limit + 1) : limit)
        .snapshots();

    return stream;
  }

  Future<DocumentReference<Map<String, dynamic>>> addEntry({
    String? title,
    String? description,
    DateTime? date,
    String? tag,
  }) {
    final collection = getTodos();
    final result = collection.add(
      {
        'title': title,
        'tag': tag,
        'description': description,
        'date': date,
        'done': false,
        'index': 0,
        'timestamp': FieldValue.serverTimestamp(),
      },
    );

    return result;
  }

  Future<void> deleteEntry({
    required DocumentReference<Object?> doc,
  }) {
    return doc.delete();
  }

  // Future<void> updateEntry({
  //   required DocumentReference<Object?> doc,
  //   required EntryModel entry,
  // }) {
  //   return doc.update(entry.toMap());
  // }
}
