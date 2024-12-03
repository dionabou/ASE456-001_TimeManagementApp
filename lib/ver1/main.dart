import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'input_screen.dart';
import 'query_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDh90MiiDbj7mxxw6FyA7VRa-eiv5majYo",
      authDomain: "timemanagementapp-99eb3.firebaseapp.com",
      projectId: "timemanagementapp-99eb3",
      storageBucket: "timemanagementapp-99eb3.firebasestorage.app",
      messagingSenderId: "683097529168",
      appId: "1:683097529168:web:51c46351c7a083ebea6a55",
      measurementId: "G-BD1ZX011T6",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Management App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.input, color: Colors.blue),
                title: const Text(
                  'Go to Input Screen',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InputScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.query_stats, color: Colors.green),
                title: const Text(
                  'Go to Query Screen',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QueryScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
