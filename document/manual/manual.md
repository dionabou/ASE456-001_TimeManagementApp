
# User Manual for the Time Management App

This manual provides comprehensive instructions for using the Time Management App. The app helps students manage their time by recording tasks, querying data, and generating reports.

---

## 1. Overview

The Time Management App allows users to:
- Record tasks with details such as date, start time, end time, task description, and tag.
- Query tasks based on date, task name, or tag.
- Generate time usage reports and prioritize tasks (Ver2).

---

## 2. Installation

### Prerequisites:
- **Mobile Device**: Android or iOS.
- **Firebase Account**: Required for storing and retrieving data.

### Steps to Install:
1. Download the app from the official store:
   - Android: Google Play Store.
   - iOS: Apple App Store.
2. Launch the app after installation.
3. Log in using your Firebase credentials or create an account.

---

## 3. Features

### 3.1 Recording Tasks
1. Navigate to the **Record Task** screen.
2. Enter the following details:
   - **Date**: Use the `YYYY-MM-DD` format to specify the task date (e.g., `2023-11-25`).
   - **From**: Specify the start time in `HH:MM AM/PM` format (e.g., `09:00 AM`).
   - **To**: Specify the end time in `HH:MM AM/PM` format (e.g., `10:00 AM`).
   - **Task**: Provide a brief description of the task (e.g., `Study Flutter`).
   - **Tag**: Categorize the task with a tag (e.g., `Study`, `Work`, `Exercise`).
3. Press the **Save Task** button.
4. A success message will display at the top of the screen if the task is saved successfully. Fields will reset automatically for a new entry.

### 3.2 Querying Tasks
1. Open the **Query Task** screen.
2. Enter your query criteria:
   - **Date**: Retrieve all tasks completed on a specific date.
   - **Task**: Retrieve all instances of a specific task description.
   - **Tag**: Retrieve all tasks associated with a specific tag.
3. Press the **Search** button.
4. Results matching the query criteria will be displayed.

---

## 4. Advanced Features (Ver2)

### 4.1 Generating Reports
1. Open the **Query Task** screen.
2. Enter a date range (e.g., `2021-01-01` to `2022-01-01`).
3. Press the **Search** button to fetch tasks within the range.
4. View a report summarizing time usage across the specified period.

### 4.2 Prioritizing Tasks
1. Use the **Prioritize** checkbox on the Query screen.
2. Tasks will automatically sort by time spent (from highest to lowest) when checked.
3. Uncheck the box to return to the original query order.

---

## 5. Troubleshooting

### Common Issues and Solutions:
1. **Unable to Save a Task:**
   - Ensure all fields are filled out accurately.
   - Verify internet connectivity.
   - Confirm correct input format for date and time.

2. **No Results Returned for a Query:**
   - Double-check query criteria (e.g., correct date or spelling of task/tag).
   - Confirm tasks have been recorded in the database.

3. **App Freezes or Crashes:**
   - Restart the app and try again.
   - Ensure you are using the latest version of the app.

4. **Error Messages During Task Entry:**
   - Check for specific error messages (e.g., invalid date or time format) and correct input accordingly.

---

## 6. Frequently Asked Questions (FAQs)

### **Q: Can I record tasks with overlapping times?**
A: Yes, overlapping tasks can be recorded, but they will appear as separate entries in the query results.

### **Q: How do I edit a saved task?**
A: Editing tasks is not available in the current version. You may delete the task from the database and re-enter it.

### **Q: How do I view tasks across multiple days?**
A: Use the date range feature in the **Query Task** screen to retrieve tasks for multiple days.

---

## 7. Contact Support

For further assistance, reach out to our support team:
- **Email:** support@timemanagerapp.com
- **Phone:** +1-800-555-1234

---

Thank you for using the Time Management App. Start tracking your time effectively today!
