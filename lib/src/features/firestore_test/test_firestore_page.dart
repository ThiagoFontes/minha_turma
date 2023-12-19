import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myclasses/src/utils/states/snapshot_states.dart';

class TestFirestorePage extends StatefulWidget {
  const TestFirestorePage({super.key});

  static const String route = '/test_firestore';

  @override
  State<TestFirestorePage> createState() => _TestFirestorePageState();
}

class _TestFirestorePageState extends State<TestFirestorePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final db = FirebaseFirestore.instance;

  String path = 'coaches', data = '', type = 'collection';
  Stream<QuerySnapshot<Map<String, dynamic>>>? streamCollection;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? streamDocument;

  late TextEditingController pathController;

  @override
  void initState() {
    streamCollection = db.collection(path).snapshots();
    pathController = TextEditingController(text: path);

    super.initState();
  }

  String updateType() {
    final pathSplitList = path.split('/');

    type = (pathSplitList.length % 2 == 1) ? 'collection' : 'document';

    return type;
  }

  create() {
    firestoreExecute(
      document: () {
        db.doc(path).set(jsonDecode(data));
      },
      collection: () {
        db.collection(path).add(jsonDecode(data));
      },
    );
  }

  read() {
    firestoreExecute(
      document: () {
        streamDocument = db.doc(path).snapshots(
              includeMetadataChanges: true,
            );
      },
      collection: () {
        streamCollection = db.collection(path).snapshots(
              includeMetadataChanges: true,
            );
      },
    );
  }

  update() {
    firestoreExecute(
      document: () {
        db.doc(path).update(jsonDecode(data));
      },
      collection: () {
        db.collection(path).add(jsonDecode(data));
      },
    );
  }

  delete() {
    firestoreExecute(
      document: () {
        db.doc(path).delete();
      },
      collection: () {
        log('Deleting collections from the client is not recommended.');
      },
    );
  }

  firestoreExecute({required Function document, required Function collection}) {
    updateType();
    setState(() {
      if (type == 'document') {
        document();
      } else {
        collection();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;
    updateType();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Testing'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('email: ${user?.email}'),
                Row(
                  children: [
                    Text('id: ${user?.uid}'),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () async => Clipboard.setData(
                        ClipboardData(text: user?.uid ?? ''),
                      ),
                      child: const Icon(Icons.copy, size: 18),
                    )
                  ],
                ),
                Text('Tipo de doc: $type'),
                TextFormField(
                  controller: pathController,
                  decoration: InputDecoration(
                    labelText: 'Path',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    suffix: GestureDetector(
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.backspace_outlined,
                          size: 18,
                        ),
                      ),
                      onTap: () {
                        final auxList = path.split('/');
                        if (auxList.length > 1) {
                          auxList.removeLast();
                        }
                        path = auxList.join('/');
                        pathController.text = path;
                        read();
                      },
                    ),
                  ),
                  onChanged: (newValue) => path = newValue,
                  onSaved: (newValue) {
                    path = newValue ?? '';
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Value',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onChanged: (newValue) => data = newValue,
                  onSaved: (newValue) => data = newValue ?? '',
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        create();
                      },
                      child: const Text('Create'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        read();
                      },
                      child: const Text('Read'),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: updateType() == 'document'
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline,
                      ),
                      onPressed: () {
                        update();
                      },
                      child: const Text('Update'),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: updateType() == 'document'
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline,
                      ),
                      onPressed: () {
                        delete();
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
                Center(
                  child: OutlinedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: const Text('logout'),
                  ),
                ),
                const SizedBox(height: 8),
                if (type == 'collection')
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: streamCollection,
                    builder: (context, snapshot) {
                      log('cached: ${snapshot.data?.metadata.isFromCache}');
                      return SnapshotStates(
                        snapshot: snapshot,
                        child: CollectionInfoWidget(
                          path: path,
                          theme: theme,
                          snapshot: snapshot,
                          onDocumentClick: (id) {
                            path = '$path/$id';
                            pathController.text = path;
                            read();
                          },
                        ),
                      );
                    },
                  ),
                if (type == 'document')
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: streamDocument,
                    builder: (context, snapshot) {
                      log('cached: ${snapshot.data?.metadata.isFromCache}');
                      return SnapshotStates(
                        snapshot: snapshot,
                        child: DocInfoWidget(
                          path: path,
                          theme: theme,
                          snapshot: snapshot,
                          onCollectionClick: (id) {
                            path = '$path/$id';
                            pathController.text = path;
                            read();
                          },
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DocInfoWidget extends StatelessWidget {
  final String path;
  final ThemeData theme;
  final AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot;
  final Function(String id) onCollectionClick;
  const DocInfoWidget({
    super.key,
    required this.path,
    required this.theme,
    required this.snapshot,
    required this.onCollectionClick,
  });

  @override
  Widget build(BuildContext context) {
    final data = snapshot.data?.data() ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          path,
          style: theme.textTheme.titleSmall,
        ),
        if (data.containsKey('collections'))
          Builder(builder: (context) {
            final collections = data['collections'] as List<dynamic>;
            data.remove('collections');
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...collections
                    .map(
                      (e) => TextButton(
                        onPressed: () => onCollectionClick(e),
                        child: Text(e),
                      ),
                    )
                    .toList(),
              ],
            );
          }),
        Text(data.toString())
      ],
    );
  }
}

class CollectionInfoWidget extends StatelessWidget {
  const CollectionInfoWidget({
    super.key,
    required this.path,
    required this.theme,
    required this.snapshot,
    required this.onDocumentClick,
  });

  final String path;
  final ThemeData theme;
  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;
  final Function(String id) onDocumentClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          path,
          style: theme.textTheme.titleSmall,
        ),
        ...(snapshot)
                .data
                ?.docs
                .map(
                  (value) => Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'id: ${value.id}',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                          mouseCursor: SystemMouseCursors.click,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => onDocumentClick(value.id),
                        ),
                        TextSpan(text: '| value: ${value.data()}\n'),
                      ],
                    ),
                  ),
                )
                .toList() ??
            <Widget>[]
      ],
    );
  }
}
