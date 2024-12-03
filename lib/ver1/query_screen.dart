import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QueryScreen extends StatefulWidget {
  @override
  _QueryScreenState createState() => _QueryScreenState();
}

class _QueryScreenState extends State<QueryScreen> {
  final TextEditingController queryController = TextEditingController();
  String selectedField = 'date';
  List<Map<String, dynamic>> queryResults = [];
  String? errorMessage;

  final CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

  Future<void> fetchTasks() async {
    setState(() {
      errorMessage = null;
    });

    if (queryController.text.isEmpty) {
      setState(() {
        errorMessage = 'Query field cannot be empty';
      });
      return;
    }

    try {
      QuerySnapshot snapshot =
      await tasks.where(selectedField, isEqualTo: queryController.text).get();
      setState(() {
        queryResults = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        if (queryResults.isEmpty) {
          errorMessage = 'No results found!';
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch tasks. Please try again.';
      });
    }
  }

  /// Format Timestamp to readable string
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Invalid Timestamp';
    final DateTime dateTime = timestamp.toDate();
    return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Query Tasks'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (errorMessage != null)
              Container(
                color: Colors.red.shade100,
                padding: EdgeInsets.all(8),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            SizedBox(height: 10),
            TextField(
              controller: queryController,
              decoration: InputDecoration(
                labelText: 'Enter Query',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedField,
              items: [
                DropdownMenuItem(value: 'date', child: Text('Date')),
                DropdownMenuItem(value: 'task', child: Text('Task')),
                DropdownMenuItem(value: 'tag', child: Text('Tag')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedField = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search By',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchTasks,
              child: Text('Search'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: queryResults.isEmpty
                  ? Center(child: Text('No Results Found'))
                  : ListView.builder(
                itemCount: queryResults.length,
                itemBuilder: (context, index) {
                  final task = queryResults[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(task['task'] ?? 'No Task Name'),
                      subtitle: Text(
                        'Date: ${_formatTimestamp(task['date'])} | From: ${_formatTimestamp(task['from'])} | To: ${_formatTimestamp(task['to'])}',
                      ),
                      trailing: Text(task['tag'] ?? 'No Tag'),
                    ),
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
