import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController taskController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  final CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
  String? errorMessage;
  String? successMessage;

  void showDatePickerDialog(TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      controller.text = '${selectedDate.year}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.day.toString().padLeft(2, '0')}';
    }
  }

  void showTimePickerDialog(TextEditingController controller) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      final period = selectedTime.period == DayPeriod.am ? 'AM' : 'PM';
      controller.text = '${selectedTime.hourOfPeriod}:${selectedTime.minute.toString().padLeft(2, '0')} $period';
    }
  }

  void saveTask(BuildContext context) async {
    final dateText = dateController.text;
    final fromText = fromController.text;
    final toText = toController.text;
    final task = taskController.text;
    final tag = tagController.text;

    setState(() {
      errorMessage = null;
      successMessage = null;
    });

    if (dateText.isEmpty || fromText.isEmpty || toText.isEmpty || task.isEmpty || tag.isEmpty) {
      setState(() {
        errorMessage = 'All fields are required!';
      });
      return;
    }

    final dateRegex = RegExp(r'^\d{4}/\d{2}/\d{2}$');
    final timeRegex = RegExp(r'^\d{1,2}:\d{2} (AM|PM)$');

    if (!dateRegex.hasMatch(dateText)) {
      setState(() {
        errorMessage = 'Invalid date format (YYYY/MM/DD)';
      });
      return;
    }

    if (!timeRegex.hasMatch(fromText) || !timeRegex.hasMatch(toText)) {
      setState(() {
        errorMessage = 'Invalid time format (HH:MM AM/PM)';
      });
      return;
    }

    try {
      // Parse date and time into DateTime objects
      final DateTime date = DateTime.parse(dateText.replaceAll('/', '-'));
      final DateTime fromDateTime = DateTime.parse(
        dateText.replaceAll('/', '-') + 'T' + _convertTo24HourFormat(fromText),
      );
      final DateTime toDateTime = DateTime.parse(
        dateText.replaceAll('/', '-') + 'T' + _convertTo24HourFormat(toText),
      );

      if (toDateTime.isBefore(fromDateTime)) {
        setState(() {
          errorMessage = 'End time must be after start time.';
        });
        return;
      }

      // Save to Firestore as Timestamps
      await tasks.add({
        'date': Timestamp.fromDate(date),
        'from': Timestamp.fromDate(fromDateTime),
        'to': Timestamp.fromDate(toDateTime),
        'task': task,
        'tag': tag,
      });

      setState(() {
        successMessage = 'Task saved successfully!';
        errorMessage = null;

        // Reset the form
        dateController.clear();
        fromController.clear();
        toController.clear();
        taskController.clear();
        tagController.clear();
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to save task. Please try again.';
        successMessage = null;
      });
    }
  }

  /// Convert "HH:MM AM/PM" to 24-hour format for DateTime parsing
  String _convertTo24HourFormat(String time) {
    final timeParts = time.split(' ');
    final hourMinute = timeParts[0].split(':');
    int hour = int.parse(hourMinute[0]);
    final int minute = int.parse(hourMinute[1]);

    if (timeParts[1] == 'PM' && hour != 12) {
      hour += 12;
    } else if (timeParts[1] == 'AM' && hour == 12) {
      hour = 0;
    }

    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:00';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Record Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (successMessage != null)
                Container(
                  color: Colors.green.shade100,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    successMessage!,
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
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
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Date (YYYY/MM/DD)',
                  prefixIcon: InkWell(
                    onTap: () => showDatePickerDialog(dateController),
                    child: const Icon(Icons.calendar_today),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: fromController,
                decoration: InputDecoration(
                  labelText: 'From (HH:MM AM/PM)',
                  prefixIcon: InkWell(
                    onTap: () => showTimePickerDialog(fromController),
                    child: const Icon(Icons.access_time),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: toController,
                decoration: InputDecoration(
                  labelText: 'To (HH:MM AM/PM)',
                  prefixIcon: InkWell(
                    onTap: () => showTimePickerDialog(toController),
                    child: const Icon(Icons.access_time),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: taskController,
                decoration: const InputDecoration(
                  labelText: 'Task',
                  prefixIcon: Icon(Icons.task),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: tagController,
                decoration: const InputDecoration(
                  labelText: 'Tag',
                  prefixIcon: Icon(Icons.label),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => saveTask(context),
                icon: const Icon(Icons.save),
                label: const Text('Save Task'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
