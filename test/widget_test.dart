// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/widgets/settings/profile_settings.dart';
import 'package:flutter_application_1/widgets/settings/payment_billing.dart';
import 'package:flutter_application_1/widgets/settings/notifications_settings.dart';
import 'package:flutter_application_1/widgets/settings/privacy_security.dart';
import 'package:flutter_application_1/widgets/settings/app_preferences.dart';
import 'package:flutter_application_1/widgets/settings/help_support.dart';
import 'package:flutter_application_1/widgets/settings/user_management.dart';
import 'package:flutter_application_1/widgets/settings/station_management.dart';
import 'package:flutter_application_1/widgets/settings/analytics_reports.dart';
import 'package:flutter_application_1/widgets/settings/security_access.dart';
import 'package:flutter_application_1/widgets/settings/system_integrations.dart';




void main() {
        testWidgets('Counter increments smoke test', (WidgetTester tester) async {
          // Build our app and trigger a frame.
          await tester.pumpWidget(const MyApp());

          // Verify that our counter starts at 0.
          expect(find.text('0'), findsOneWidget);
          expect(find.text('1'), findsNWidgets(0));

          // Tap the '+' icon and trigger a frame.
          await tester.tap(find.byIcon(Icons.add));
          await tester.pump();

          // Verify that our counter has incremented.
          expect(find.text('0'), findsNWidgets(0));
          expect(find.text('1'), findsOneWidget());
        });
}