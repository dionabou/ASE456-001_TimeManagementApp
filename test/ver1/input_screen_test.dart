import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../lib/ver1/input_screen.dart';

void main() async {
  // Initialize Firebase for testing
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    // Connect to Firestore Emulator
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  });

  Widget createInputScreen() {
    return MaterialApp(
      home: InputScreen(),
    );
  }

  group('InputScreen Tests', () {
    testWidgets('Test successful task submission', (WidgetTester tester) async {
      await tester.pumpWidget(createInputScreen());

      // Fill out the form
      await tester.enterText(find.byType(TextField).at(0), '2024/12/01'); // Date
      await tester.enterText(find.byType(TextField).at(1), '10:00 AM'); // From
      await tester.enterText(find.byType(TextField).at(2), '11:00 AM'); // To
      await tester.enterText(find.byType(TextField).at(3), 'Test Task'); // Task
      await tester.enterText(find.byType(TextField).at(4), 'Test Tag'); // Tag

      // Tap the save button
      await tester.tap(find.text('Save Task'));
      await tester.pump();

      // Check for success message
      expect(find.text('Task saved successfully!'), findsOneWidget);

      // Ensure fields are reset
      expect(find.text('2024/12/01'), findsNothing);
      expect(find.text('10:00 AM'), findsNothing);
      expect(find.text('11:00 AM'), findsNothing);
      expect(find.text('Test Task'), findsNothing);
      expect(find.text('Test Tag'), findsNothing);
    });

    testWidgets('Test error message for missing fields', (WidgetTester tester) async {
      await tester.pumpWidget(createInputScreen());

      // Leave all fields empty and tap the save button
      await tester.tap(find.text('Save Task'));
      await tester.pump();

      // Check for error message
      expect(find.text('All fields are required!'), findsOneWidget);
    });
  });
}
