import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../lib/ver1/query_screen.dart';

void main() async {
  // Initialize Firebase for testing
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    // Connect to Firestore Emulator
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  });

  Widget createQueryScreen() {
    return MaterialApp(
      home: QueryScreen(),
    );
  }

  group('QueryScreen Tests', () {
    testWidgets('Test successful query and results display', (WidgetTester tester) async {
      await tester.pumpWidget(createQueryScreen());

      // Fill out the query
      await tester.enterText(find.byType(TextField), 'Test Date');
      await tester.tap(find.byType(DropdownButtonFormField).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Date').last);
      await tester.pump();

      // Tap the Search button
      await tester.tap(find.text('Search'));
      await tester.pump();

      // Check that results are displayed
      expect(find.text('No Results Found'), findsNothing);
      expect(find.textContaining('Date:'), findsWidgets); // Verify task details appear
    });

    testWidgets('Test empty query input displays error', (WidgetTester tester) async {
      await tester.pumpWidget(createQueryScreen());

      // Leave query input empty and tap the Search button
      await tester.tap(find.text('Search'));
      await tester.pump();

      // Check for error message
      expect(find.text('Query field cannot be empty'), findsOneWidget);
    });

    testWidgets('Test no results found for a query', (WidgetTester tester) async {
      await tester.pumpWidget(createQueryScreen());

      // Fill out the query with a non-existent value
      await tester.enterText(find.byType(TextField), 'Non-existent');
      await tester.tap(find.text('Search'));
      await tester.pump();

      // Check for "No Results Found" message
      expect(find.text('No results found!'), findsOneWidget);
    });

    testWidgets('Test dropdown field selection changes query criteria', (WidgetTester tester) async {
      await tester.pumpWidget(createQueryScreen());

      // Verify default dropdown selection is 'date'
      expect(find.text('Date'), findsOneWidget);

      // Change dropdown selection to 'task'
      await tester.tap(find.byType(DropdownButtonFormField).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Task').last);
      await tester.pump();

      // Ensure the selected value is updated
      expect(find.text('Task'), findsOneWidget);
    });
  });
}
