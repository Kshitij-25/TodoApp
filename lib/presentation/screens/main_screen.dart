import 'package:flutter/material.dart';

import '../components/add_task_sheet.dart';
import '../components/app_bottom_nav.dart';
import 'calendar_screen.dart';
import 'home_screen.dart';
import 'insights_screen.dart';
import 'task_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const routeName = '/main';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const TaskListScreen(),
    const CalendarScreen(),
    const InsightsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      extendBody: true,
      floatingActionButton: AppFab(
        onPressed: () => _showAddTaskSheet(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        onAddTap: () => _showAddTaskSheet(context),
      ),
    );
  }

  void _showAddTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTaskSheet(),
    );
  }
}
