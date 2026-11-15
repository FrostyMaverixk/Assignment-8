import 'package:flutter/material.dart';

class SavedEventsBanner extends StatelessWidget {
  const SavedEventsBanner({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      content: const Text('No connection. Showing the events saved earlier.'),
      actions: [TextButton(onPressed: onRetry, child: const Text('Retry'))],
    );
  }
}
