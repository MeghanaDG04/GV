import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/admin_provider.dart';

class YourWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Option 1: Using Consumer
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        return Text('User count: ${adminProvider.users.length}');
      },
    );
    
    // Option 2: Using Provider.of
    // final adminProvider = Provider.of<AdminProvider>(context);
    // return Text('User count: ${adminProvider.users.length}');
    
    // Option 3: Using context.watch() (requires provider package)
    // return Text('User count: ${context.watch<AdminProvider>().users.length}');
  }
}
