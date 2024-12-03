
# Manual Test Cases for Ver1

## **Input Screen**
### **Test Case ID**: IS001
- **Description**: Verify all input fields (`Date`, `From`, `To`, `Task`, `Tag`) accept valid data.
- **Steps**:
  1. Launch the application.
  2. Navigate to the Input Screen.
  3. Enter valid data:
     - `Date`: `2024/12/01`
     - `From`: `10:00 AM`
     - `To`: `11:00 AM`
     - `Task`: `Studied Java`
     - `Tag`: `Study`
  4. Tap `Save Task`.
- **Expected Result**: Data is saved successfully, and fields are cleared with a success message displayed.

### **Test Case ID**: IS002
- **Description**: Verify the app shows an error message when a required field is missing.
- **Steps**:
  1. Leave one or more fields empty.
  2. Tap `Save Task`.
- **Expected Result**: Error message displayed: `All fields are required!`.

## **Query Screen**
### **Test Case ID**: QS001
- **Description**: Verify the query functionality for a specific date.
- **Steps**:
  1. Navigate to the Query Screen.
  2. Enter a valid date (`2024/12/01`) in the query field.
  3. Tap `Search`.
- **Expected Result**: A list of activities for the specified date is displayed.

### **Test Case ID**: QS002
- **Description**: Verify the query functionality for a specific task.
- **Steps**:
  1. Enter a valid task (`Studied Java`) in the query field.
  2. Tap `Search`.
- **Expected Result**: A list of activities for the specified task is displayed.

## **General Validation**
### **Test Case ID**: GV001
- **Description**: Verify the app handles invalid date formats gracefully.
- **Steps**:
  1. Enter an invalid date (`12/01/2024`) in the `Date` field on the Input Screen.
  2. Tap `Save Task`.
- **Expected Result**: Error message displayed: `Invalid date format (YYYY/MM/DD)`.
