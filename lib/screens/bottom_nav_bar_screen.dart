/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/home_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/user_profile.dart';
import '../screens/cart_screen.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({Key? key}) : super(key: key);

  @override
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  // Currently selected index
  int _selectedIndex = 0;

  // Define navigation icons
  final List<IconData> _navigationIcons = [
    Icons.home_rounded,
    Icons.receipt_long_rounded,
    Icons.person_rounded,
    Icons.shopping_cart_rounded,
  ];

  // Pages for the Bottom Navigation
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(),
      OrdersScreen(),
      UserProfileScreen(),
      CartScreen(),
    ];
  }

  // Handle navigation item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildCustomBottomNavBar(),
    );
  }

  Widget _buildCustomBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, -3),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              _navigationIcons.length,
              (index) => _buildNavItem(
                icon: _navigationIcons[index],
                index: index,
                isSelected: _selectedIndex == index,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected 
            ? Colors.black.withOpacity(0.1) 
            : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : Colors.grey,
              size: isSelected ? 28 : 24,
            ),
            if (isSelected) ...[
              SizedBox(width: 8),
              Text(
                _getNavItemLabel(index),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  // Get label for navigation item
  String _getNavItemLabel(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Orders';
      case 2:
        return 'Profile';
      case 3:
        return 'Cart';
      default:
        return '';
    }
  }
}

// Optional: Custom Navigation Wrapper
class CustomNavigationWrapper extends StatelessWidget {
  final Widget child;

  const CustomNavigationWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.5),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}*/



import 'package:ecommerce_app/screens/homie_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/home_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/user_profile.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({Key? key}) : super(key: key);

  @override
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  // Currently selected index
  int _selectedIndex = 0;

  // Page controller for PageView (used for swiping between pages)
  final PageController _pageController = PageController();

  // Define navigation icons
  final List<IconData> _navigationIcons = [
    Icons.home_rounded,
    Icons.receipt_long_rounded,
    Icons.person_rounded,
  ];

  // Pages for the Bottom Navigation
  Widget _getCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        return HomeScreen();
      case 1:
        return OrdersScreen();
      case 2:
        return UserProfileScreen();
      default:
        return HomeScreen();
    }
  }

  // Handle navigation item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);  // Navigate the page controller to the correct page
  }

  // Handle page swipe
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged, // Listen for page changes when swiping
          children: [
            HomieScreen(),
            OrdersScreen(),
            UserProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: _buildCustomBottomNavBar(),
    );
  }

  Widget _buildCustomBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              _navigationIcons.length,
              (index) => _buildNavItem(
                icon: _navigationIcons[index],
                index: index,
                isSelected: _selectedIndex == index,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.black.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : Colors.grey,
              size: isSelected ? 28 : 24,
            ),
            if (isSelected) ...[
              SizedBox(width: 8),
              Text(
                _getNavItemLabel(index),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  // Get label for navigation item
  String _getNavItemLabel(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Orders';
      case 2:
        return 'Profile';
      default:
        return '';
    }
  }
}



/*import 'package:ecommerce_app/screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../screens/home_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/cart_screen.dart';

class BottomNavBarScreen extends StatefulWidget {
  @override
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  // Initially, the selected index is 0 (Home tab)
  int _selectedIndex = 0;

  // Pages for the Bottom Navigation
  final List<Widget> _pages = [
    HomeScreen(),  // Page for Home
    OrdersScreen(), // Page for Orders
    UserProfileScreen(),   // Page for Cart
  ];

  // Called when an item in the bottom navigation bar is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No AppBar, as per your request
      body: IndexedStack(
        index: _selectedIndex,  // Show the selected page based on the index
        children: _pages,       // List of pages for the bottom navigation bar
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,  // Home tab is selected initially
        onTap: _onItemTapped,  // Change tab when the user taps an item
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 5,
      ),
    );
  }
}*/