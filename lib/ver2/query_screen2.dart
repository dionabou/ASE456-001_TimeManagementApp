import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QueryScreen2 extends StatefulWidget {
  @override
  _QueryScreen2State createState() => _QueryScreen2State();
}

class _QueryScreen2State extends State<QueryScreen2> {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController queryController = TextEditingController();
  String selectedField = 'date';
  List<Map<String, dynamic>> queryResults = [];
  List<Map<String, dynamic>> originalQueryResults = []; // Stores original results
  String? errorMessage;
  bool prioritize = false;

  final CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

  /// Show Date Picker for selecting dates
  void showDatePickerDialog(TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      controller.text =
      '${selectedDate.year}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.day.toString().padLeft(2, '0')}';
    }
  }

  /// Fetch tasks within a date range
  Future<void> fetchTasksByDateRange() async {
    setState(() {
      errorMessage = null;
    });

    if (startDateController.text.isEmpty || endDateController.text.isEmpty) {
      setState(() {
        errorMessage = 'Both start and end dates are required!';
      });
      return;
    }

    try {
      DateTime startDate = DateTime.parse(startDateController.text.replaceAll('/', '-'));
      DateTime endDate = DateTime.parse(endDateController.text.replaceAll('/', '-'));

      QuerySnapshot snapshot = await tasks
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      setState(() {
        queryResults = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        originalQueryResults = List.from(queryResults); // Store original results

        queryResults = queryResults.where((task) => task['from'] != null && task['to'] != null).toList();

        if (prioritize) {
          _applyPrioritization();
        }
      });

      if (queryResults.isEmpty) {
        setState(() {
          errorMessage = 'No results found in this date range!';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch tasks. Please try again.';
      });
    }
  }

  /// Fetch tasks based on selected field and query value
  Future<void> fetchTasksBySearch() async {
    setState(() {
      errorMessage = null;
    });

    if (queryController.text.isEmpty) {
      setState(() {
        errorMessage = 'Query field cannot be empty!';
      });
      return;
    }

    try {
      QuerySnapshot snapshot = await tasks.where(selectedField, isEqualTo: queryController.text).get();

      setState(() {
        queryResults = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

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

  /// Apply prioritization by sorting tasks based on time spent
  void _applyPrioritization() {
    queryResults.sort((a, b) {
      final aDuration = _calculateTimeSpent(a['from'], a['to']);
      final bDuration = _calculateTimeSpent(b['from'], b['to']);
      return bDuration.compareTo(aDuration); // Sort descending by time spent
    });
  }

  /// Calculate time spent in minutes
  int _calculateTimeSpent(Timestamp from, Timestamp to) {
    final fromDateTime = from.toDate();
    final toDateTime = to.toDate();
    return toDateTime.difference(fromDateTime).inMinutes;
  }

  /// Toggle prioritization dynamically
  void _togglePrioritization(bool value) {
    setState(() {
      prioritize = value;
      if (prioritize) {
        _applyPrioritization();
      } else {
        queryResults = List.from(originalQueryResults); // Reset to original results
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Query & Reports'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (errorMessage != null)
                Container(
                  color: Colors.red.shade100,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              const SizedBox(height: 10),
              // Search Functionality
              TextField(
                controller: queryController,
                decoration: InputDecoration(
                  labelText: 'Enter Query',
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedField,
                items: const [
                  DropdownMenuItem(value: 'date', child: Text('Date')),
                  DropdownMenuItem(value: 'task', child: Text('Task')),
                  DropdownMenuItem(value: 'tag', child: Text('Tag')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedField = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Search By',
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: fetchTasksBySearch,
                child: const Text('Search'),
              ),
              const Divider(height: 20),
              // Date Range Functionality
              TextField(
                controller: startDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Start Date (YYYY/MM/DD)',
                  prefixIcon: InkWell(
                    onTap: () => showDatePickerDialog(startDateController),
                    child: const Icon(Icons.calendar_today),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: endDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'End Date (YYYY/MM/DD)',
                  prefixIcon: InkWell(
                    onTap: () => showDatePickerDialog(endDateController),
                    child: const Icon(Icons.calendar_today),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: fetchTasksByDateRange,
                      child: const Text('Fetch Tasks'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Checkbox(
                    value: prioritize,
                    onChanged: (value) => _togglePrioritization(value!),
                  ),
                  const Text('Prioritize'),
                ],
              ),
              const SizedBox(height: 20),
              queryResults.isEmpty
                  ? const Center(child: Text('No Results Found'))
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: queryResults.length,
                itemBuilder: (context, index) {
                  final task = queryResults[index];
                  final timeSpent = _calculateTimeSpent(task['from'], task['to']);
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(task['task'] ?? 'No Task'),
                          Text('${timeSpent ~/ 60}h ${timeSpent % 60}m'),
                        ],
                      ),
                      subtitle: Text(
                        'Date: ${task['date'].toDate()} | Tag: ${task['tag'] ?? 'No Tag'}',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
