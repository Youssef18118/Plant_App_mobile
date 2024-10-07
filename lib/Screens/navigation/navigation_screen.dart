import "package:flashy_tab_bar2/flashy_tab_bar2.dart";
import 'package:flutter/material.dart';
import 'package:plant_app/Screens/Species/speciesScreen.dart';
import 'package:plant_app/Screens/home/home_screen.dart';
import 'package:plant_app/Screens/profile/profileScreen.dart';
import 'package:plant_icons/plant_icons_data.dart';

class NavigationScreen extends StatefulWidget {
  final int selectedIndex;

  const NavigationScreen({Key? key, this.selectedIndex = 0}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.selectedIndex;
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const Speciesscreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: FlashyTabBar(
        height: 55,
        iconSize: 25,
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          FlashyTabBarItem(
            icon: const Icon(
              Icons.home,
              color: Colors.black,
            ),
            title: const Text('Home'),
            activeColor: Colors.blue,
          ),
          FlashyTabBarItem(
            icon: const Icon(
              Icons.grid_view_rounded,
              color: Colors.black,
            ),
            title: const Text('Plants'),
            activeColor: Colors.green,
          ),
          FlashyTabBarItem(
            icon: const Icon(
              Icons.person,
              color: Colors.black,
            ),
            title: const Text('Profile'),
            activeColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
