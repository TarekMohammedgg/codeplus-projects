import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/features/common/bottom_navigation_bar/presentation/widgets/main_bottom_navigation_bar.dart';

class PatientShell extends StatelessWidget {
  const PatientShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: MainBottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
