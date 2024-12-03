
# Manual Test Cases for Ver2

## **Input Screen Enhancements**
### **Test Case ID**: ISV201
- **Description**: Verify the input screen supports the same functionality as Ver1 with additional validation for overlapping time.
- **Steps**:
  1. Enter overlapping time ranges (e.g., `10:00 AM - 11:00 AM` followed by `10:30 AM - 11:30 AM`).
  2. Tap `Save Task`.
- **Expected Result**: Error message displayed: `Time ranges cannot overlap.`

## **Query Screen Enhancements**
### **Test Case ID**: QSV201
- **Description**: Verify the report generation functionality for a date range.
- **Steps**:
  1. Enter a valid date range (`2024/12/01 - 2024/12/31`) in the Query Screen.
  2. Tap `Generate Report`.
- **Expected Result**: Report displaying all activities within the date range, grouped by tag or task.

## **Prioritization**
### **Test Case ID**: PR001
- **Description**: Verify activities are sorted by time spent when the `Prioritize` checkbox is selected.
- **Steps**:
  1. Navigate to the Query Screen.
  2. Perform a query for activities.
  3. Check the `Prioritize` checkbox.
- **Expected Result**: Activities are sorted in descending order of time spent.
