import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:myclasses/src/utils/localization/l10n.dart';

class SnapshotStates extends StatelessWidget {
  final AsyncSnapshot<dynamic> snapshot;
  final Widget child;
  const SnapshotStates({
    super.key,
    required this.snapshot,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (snapshot.hasError) {
      return Center(
        child: Text('${l10n.error}: ${snapshot.error}'),
      );
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!snapshot.hasData) {
      log('No data available  ${snapshot.toString()}');

      return const EmptyData();
    }

    try {
      if (snapshot.data?.docs.isEmpty) {
        const EmptyData();
      }
    } catch (_) {}

    return child;
  }
}

class EmptyData extends StatelessWidget {
  const EmptyData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(64.0),
        child: Text(l10n.noItens),
      ),
    );
  }
}
