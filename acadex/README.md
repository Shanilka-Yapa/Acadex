
# Acadex

<p align="center">
  <b>A personal academic management app for university students.</b>
</p>

<p align="center">
  Manage your GPA, attendance, timetable, exams, and assignments in one place.
</p>

---

## 📱 About Acadex

**Acadex** is a mobile application built with Flutter to help university students organize and manage their academic life.

Instead of keeping academic information scattered across notebooks, spreadsheets, calendars, and different apps, Acadex brings the most important academic tools together in a single application.

The app is designed with a modern, clean interface using a dark navy and cyan visual theme.

---

## ✨ Features

### 🏠 Dashboard

The dashboard provides a quick overview of your academic activities.

- Current GPA
- Overall attendance
- Pending assignments and tasks
- Upcoming academic activities
- Quick access to important sections
- Personalized student profile

---

### 🎓 GPA Calculator

Calculate and track your semester and cumulative GPA.

- Add multiple semesters
- Add modules for each semester
- Enter module credits
- Select obtained grades
- Support weighted GPA calculations
- Separate GPA and non-GPA modules
- View semester GPA
- Track overall academic performance

#### Grade Point Scale

| Grade | Grade Point |
|-------|-------------|
| A+    | 4.0         |
| A     | 4.0         |
| A-    | 3.7         |
| B+    | 3.3         |
| B     | 3.0         |
| B-    | 2.7         |
| C+    | 2.3         |
| C     | 2.0         |
| C-    | 1.7         |
| E     | 0.0         |

---

### 📊 Attendance Tracker

Track attendance for each university module.

- Add modules
- Record attended classes
- Record missed classes
- Track attendance by hours
- Calculate attendance percentage
- View attendance separately for each module
- Quickly identify modules with low attendance

Attendance is calculated using:

```text
Attendance % = (Hours Attended / Total Hours) × 100
````

---

### 🗓️ Timetable

Organize your weekly university schedule.

* Add timetable modules
* Set module code and name
* Add class days
* Set start and end times
* Assign colors to modules
* View classes by day
* View weekly module schedules
* Edit and delete timetable entries

---

### 📝 Assignments

Keep track of assignments, quizzes, and other academic tasks.

* Add assignments
* Select modules from the timetable
* Add custom modules
* Set assignment dates
* Add deadlines
* Set start times for quizzes/exams
* Specify assignment type
* Open Book / Closed Book
* Add location
* Add descriptions and parts to cover
* Edit assignments
* Delete assignments
* Mark assignments as completed
* View assignments grouped by date

Supported assignment types include:

* Take Home
* Quiz
* Essay Exam

---

### 🧾 Exams

Manage upcoming examinations and assessment events.

* Add exams
* Select modules from the timetable
* Add custom modules
* Set examination date
* Set start and end times
* Add examination location
* Edit exam details
* Delete exams
* Mark exams as completed
* View exams organized by date

---

## 🎨 UI & Design

Acadex uses a modern academic dashboard design focused on simplicity and readability.

### Design principles

* Modern mobile-first interface
* Dark navy visual theme
* Cyan accent colors
* Rounded cards
* Minimal and clean layouts
* Consistent icons
* Clear typography
* Responsive Flutter widgets
* Smooth navigation between academic tools

---

## 🛠️ Tech Stack

### Frontend

* **Flutter**
* **Dart**
* Material Design

### Local Storage

* **Hive CE**
* `hive_ce_flutter`

Acadex uses local storage so academic data can be stored directly on the user's device without requiring an online backend.

### Development Tools

* Visual Studio Code
* Git
* GitHub
* Flutter SDK
* Dart SDK

---

## 📂 Project Structure

```text
lib/
│
├── app.dart
│
├── main.dart
│
├── ui/
│   └── acadex_visuals.dart
│
├── dashboard/
│   └── dashboard.dart
│
├── gpa/
│   ├── gpa.dart
│   ├── gpa_module_model.dart
│   ├── grade_points.dart
│   └── semester_model.dart
│
├── attendance/
│   ├── attendance.dart
│   └── attendance_model.dart
│
├── timetable/
│   ├── timetable.dart
│   └── timetable_model.dart
│
├── assignment/
│   ├── assignment.dart
│   └── assignment_model.dart
│
└── exam/
    ├── exam.dart
    └── exam_model.dart
```

> The exact structure may change as the project develops.

---

## 💾 Data Storage

Acadex is designed as a local-first application.

Academic information such as:

* GPA records
* Semester information
* Module details
* Attendance records
* Timetable entries
* Assignments
* Exams

is stored locally on the device using Hive CE.

This allows the application to work without requiring a remote database or constant internet connection.

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

* Flutter SDK
* Dart SDK
* Android Studio or Visual Studio Code
* Android emulator or a physical Android device

Check your Flutter installation:

```bash
flutter doctor
```

---

### Installation

Clone the repository:

```bash
git clone <your-repository-url>
```

Navigate to the project:

```bash
cd acadex
```

Install dependencies:

```bash
flutter pub get
```

Generate Hive adapters if required:

```bash
dart run build_runner build
```

Run the application:

```bash
flutter run
```

---

## 📱 Supported Platform

Acadex is currently being developed primarily as a **mobile application** using Flutter.

The main target is:

* Android

Additional platforms may be supported in the future.

---

## 🔮 Future Improvements

Planned improvements may include:

* 📈 Academic performance analytics
* 📊 GPA and attendance charts
* 🔔 Assignment and exam reminders
* 📅 Calendar integration
* ☁️ Optional cloud backup
* 🔄 Data synchronization across devices
* 📤 Export academic data
* 🎯 Academic goal tracking
* 🌓 Theme customization
* 🔐 App-level security
* 📚 More advanced study planning tools

---

## 🎯 Project Goal

The goal of Acadex is to create a simple personal academic companion that helps university students:

> **Plan better. Track smarter. Stay on top of university life.**

---

## 👩‍💻 Developer

Developed as a personal university productivity project using Flutter and Dart.

---

## 📄 License

This project is currently intended for personal and educational use.

```

