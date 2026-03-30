# TaskFlow

A comprehensive, cross-platform Flutter application for efficient task management with advanced features like search, filtering, sorting, and visual analytics.

## 📋 Description

TaskFlow is a modern todo app built with Flutter and Dart, designed to help users organize their tasks effectively. It offers rich task metadata, offline persistence, and a sleek Material Design 3 interface. Whether you're managing personal chores, work projects, or long-term goals, TaskFlow provides the tools to stay productive and track progress.

## ✨ Features

- **Task Management**: Create, edit, delete, and mark tasks as completed with detailed metadata including title, notes, priority (low/medium/high), category, and due dates.
- **Advanced Search & Filtering**: Search tasks by title or notes, filter by status (all/completed/pending/overdue), multiple priorities, and categories. Visual filter chips for easy management.
- **Flexible Sorting**: Sort tasks by creation date, due date, priority, alphabetical order, or category.
- **Visual Analytics**: Dedicated statistics page with pie charts showing completion progress, completion rates, and breakdowns by category and priority.
- **Offline Persistence**: All data is stored locally using Hive database, ensuring tasks persist across app restarts without requiring internet.
- **Interactive UI**: Smooth animations, swipe gestures for edit/delete, expandable task details, and responsive design.
- **Cross-Platform**: Runs on Android, iOS, and other platforms supported by Flutter.

## 📸 Screenshots

- Home screen with task list and search/filter options
<img width="30%" height="30%" alt="Screenshot_1774871423" src="https://github.com/user-attachments/assets/77d6a860-90d9-4108-8779-a4dd71f6ce9d" />
<img width="30%" height="30%" alt="Screenshot_1774871371" src="https://github.com/user-attachments/assets/bd32b2bc-e709-405e-93f3-f8f12797c935" />
<img width="30%" height="30%" alt="Screenshot_1774871383" src="https://github.com/user-attachments/assets/5c8139f4-fbe8-4727-952d-750e3a65324b" />

- Task detail view with full information
<img width="30%" height="30%" alt="Screenshot_1774871363" src="https://github.com/user-attachments/assets/7d370d29-6686-4337-8b33-001e7f985142" />

- Statistics dashboard with charts
<img width="30%" height="30%" alt="Screenshot_1774871393" src="https://github.com/user-attachments/assets/3742db04-db76-4575-82cd-dcf2a26aa546" />
<img width="30%" height="30%" alt="Screenshot_1774871405" src="https://github.com/user-attachments/assets/c9e21b5c-5c91-4c39-914e-a6f97859b15a" />
<img width="30%" height="30%" alt="Screenshot_1774871410" src="https://github.com/user-attachments/assets/548a6d5f-3ed1-413a-9973-75b7af7b6200" />

- Add/edit task dialog
<img width="30%" height="30%" alt="Screenshot_1774871354" src="https://github.com/user-attachments/assets/ebb3b45d-0a20-4549-8360-0b0e3b2e316b" />

## 🚀 Installation

### Prerequisites

- Flutter SDK (version 3.11.4 or higher)
- Dart SDK
- Android Studio or VS Code with Flutter extensions
- Android/iOS emulator or physical device

### Steps

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/taskflow.git
   cd taskflow
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   - For Android: `flutter run`
   - For iOS: `flutter run` (on macOS with Xcode)
   - For web: `flutter run -d chrome`

4. **Build for production**:
   ```bash
   flutter build apk  # For Android
   flutter build ios  # For iOS
   ```

## 📖 Usage

1. **Launch the app**: On first run, you'll see welcome tasks.
2. **Add a task**: Tap the floating action button (+) to create a new task with title, notes, priority, category, and due date.
3. **Manage tasks**: Tap a task to view details, swipe to edit/delete, or mark as completed.
4. **Search and filter**: Use the search bar and filter options to find specific tasks.
5. **View statistics**: Access the analytics page from the app bar to see progress charts.
6. **Sort tasks**: Use the sort menu to organize your task list.

## 🛠️ Technologies Used

- **Flutter**: UI framework for cross-platform development
- **Dart**: Programming language
- **Hive**: Local NoSQL database for data persistence
- **fl_chart**: Library for creating charts and graphs
- **flutter_slidable**: For swipe gestures
- **intl**: For date and time formatting
- **animations**: For smooth UI transitions

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature/your-feature`
5. Open a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👤 Author

Faraz Ahmed - farazahmedofficial@outlook.com

---

*Built with ❤️ using Flutter*
