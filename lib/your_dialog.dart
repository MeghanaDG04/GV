import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/admin_provider.dart';
import 'package:provider/provider.dart';

void showYourDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      // Use the original context to access the provider
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      
      return AlertDialog(
        title: Text('Admin Info'),
        content: Text('User count: ${adminProvider.users.length}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}
