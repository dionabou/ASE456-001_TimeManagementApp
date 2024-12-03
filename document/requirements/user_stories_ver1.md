
# User Stories - Version 1 (Ver1)

This document outlines the user stories derived from Jack's first email. These user stories represent the core requirements for the application's first version.

## Epic 1: Record Time Usage
- **As a student, I want to record my time usage so that I can track how I spend my day.**

### User Stories:
1. **Input Task Details**
   - As a user, I want to input the date of the task in the `DATE` field so that I can specify when the task occurred.
   - As a user, I want to input the start time of the task in the `FROM` field so that I can specify when the task started.
   - As a user, I want to input the end time of the task in the `TO` field so that I can specify when the task ended.
   - As a user, I want to input a description of the task in the `TASK` field so that I can document what I did.
   - As a user, I want to input a category for the task in the `TAG` field so that I can group tasks by type.

2. **Save Task**
   - As a user, I want to press a "Save" button to store the task details in a database so that my task data is saved for future use.

---

## Epic 2: Query Time Usage
- **As a student, I want to query my recorded tasks so that I can retrieve information about how I spent my time.**

### User Stories:
1. **Query by Date**
   - As a user, I want to input a specific date into the query field so that I can see all tasks completed on that day.

2. **Query by Task**
   - As a user, I want to input a specific task name into the query field so that I can see all instances of that task.

3. **Query by Tag**
   - As a user, I want to input a specific tag into the query field so that I can see all tasks categorized under that tag.

---

## Acceptance Criteria
1. The input form for recording tasks must have fields for `DATE`, `FROM`, `TO`, `TASK`, and `TAG`.
2. The query interface must allow users to retrieve tasks based on `DATE`, `TASK`, or `TAG`.
3. All user inputs must be stored in a Firebase database and retrievable using queries.

---


