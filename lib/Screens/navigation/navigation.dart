import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:plant_app/Screens/home/home.dart';
import 'package:plant_app/Screens/profile/profileScreen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;
  List<Widget> _screens = [
    const HomeScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: _screens[_selectedIndex],
        bottomNavigationBar: FlashyTabBar(
          height: 55,
          iconSize: 25,
          selectedIndex: _selectedIndex,
          showElevation: true, // use this to remove appBar's elevation
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
                activeColor: Colors.blue),
            FlashyTabBarItem(
                icon: const Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                title: const Text('Profile'),
                activeColor: Colors.red),
          ],
        ));
  }
}
