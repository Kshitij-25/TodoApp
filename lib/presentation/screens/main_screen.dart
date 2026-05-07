import 'package:flutter/material.dart';

import '../components/add_task_sheet.dart';
import '../components/app_bottom_nav.dart';
import 'calendar_screen.dart';
import 'home_screen.dart';
import 'insights_screen.dart';
import 'task_list_screen.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../components/sync_indicator.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});
  static const routeName = '/main';

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
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
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          const Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: SyncIndicator(),
            ),
          ),
        ],
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
