import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'widgets/home_content.dart';
import 'widgets/animated_mood_section.dart'; // New import
import 'qna_screen.dart';
import 'bot_screen.dart';
import 'package:ubk_app/booking_screen.dart';
import 'docs_screen.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  // Bottom nav items indices:
  // 0: Home, 1: Docs, 2: Q&A, 3: Bot
  int _selectedIndex = 0;
  String _selectedMood = '';

  late AnimationController _notchController;

  @override
  void initState() {
    super.initState();
    _notchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: _selectedIndex == 0 ? 1.0 : 0.0,
    );
  }

  @override
  void dispose() {
    _notchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      _notchController.forward();
    } else {
      _notchController.reverse();
    }
  }

  void _onMoodSelected(String mood) {
    setState(() {
      _selectedMood = mood;
      debugPrint('Selected mood: $_selectedMood');
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 17) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('dd MMM, yyyy');
    return formatter.format(now);
  }

  // Build the Home tab (blue header and HomeContent)

  Widget _buildHomeScreen() {
    return Column(
      children: [
        // Blue header section with balanced sizing
        Container(
          padding: const EdgeInsets.fromLTRB(16, 25, 16, 15),
          color: Colors.blue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting and notification icon row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _getCurrentDate(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Search bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.white70, fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                          isDense: true,
                        ),
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              // Mood section is now handled by AnimatedMoodSection widget
              AnimatedMoodSection(onMoodSelected: _onMoodSelected),
            ],
          ),
        ),
        // White content area with smooth curved top and blue background
        Expanded(
          child: Stack(
            children: [
              // Blue background that extends behind the curve
              Container(
                color: Colors.blue,
              ),
              // White content with curved top
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: HomeContent(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBotScreen() {
    return const BotScreen();
  }

  // Build a placeholder for the Docs screen
  Widget _buildDocsScreen() {
    return DocsScreen();
  }

  // Build the Q&A screen (from qna_screen.dart)
  Widget _buildQAScreen() {
    return const QnAScreen();
  }

  // Choose the appropriate body content based on the selected index
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeScreen();
      case 1:
        return _buildDocsScreen();
      case 2:
        return _buildQAScreen();
      case 3:
        return _buildBotScreen();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if keyboard is visible
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    
    return Scaffold(
      body: _buildBody(),
      // The FAB is now wrapped in both AnimatedSlide and AnimatedScale.
      floatingActionButton: isKeyboardVisible 
        ? null  // Hide FAB when keyboard is visible
        : AnimatedSlide(
            offset: _selectedIndex == 0 ? const Offset(0, 0) : const Offset(0, 0.6),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: AnimatedScale(
              scale: _selectedIndex == 0 ? 1.0 : 0.8,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BookingScreen(),
                    ),
                  );
                },
                backgroundColor: Colors.blue,
                elevation: 8,
                child: const Icon(
                  Icons.add,
                  size: 28,
                ),
              ),
            ),
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // The BottomAppBar remains unchanged with an animated notch.
      bottomNavigationBar: AnimatedBuilder(
        animation: _notchController,
        builder: (context, child) {
          return BottomAppBar(
            notchMargin: 10,
            shape: AnimatedCircularNotch(bumpFactor: _notchController.value),
            color: Colors.white,
            elevation: 10,
            child: SizedBox(
              height: 60,
              // Layout remains exactly as before (with a reserved gap for the FAB).
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNavItem(0, Icons.home_rounded, 'Home'),
                        _buildNavItem(1, Icons.description, 'Docs'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 60), // Reserved gap for the FAB.
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNavItem(2, Icons.question_answer_rounded, 'Q&A'),
                        _buildNavItem(3, Icons.smart_toy_rounded, 'Bot'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.blue : Colors.grey,
                size: 24,
              ),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.grey,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom animated notch shape that interpolates between a full bump and a flat line.
class AnimatedCircularNotch extends NotchedShape {
  final double bumpFactor; // 0.0 = flat, 1.0 = full bump

  const AnimatedCircularNotch({required this.bumpFactor});

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest == null || !host.overlaps(guest) || bumpFactor == 0) {
      return Path()..addRect(host);
    }

    final double notchRadius = guest.width / 2;
    const double s1 = 15;
    const double s2 = 10;
    final double r = notchRadius;
    final double a = -r - s2;
    final double b = host.top - guest.center.dy;
    final double n2 = math.sqrt(b * b * r * r * (a * a + b * b - r * r));
    final double p2xB = ((a * r * r) + n2) / (a * a + b * b);
    final double p2yB = math.sqrt(r * r - p2xB * p2xB);

    final List<Offset> p = [
      Offset(a - s1, b),
      Offset(a, b),
      Offset(p2xB, -p2yB),
      Offset(-p2xB, -p2yB),
      Offset(-a, b),
      Offset(-a + s1, b),
    ];

    // Scale each notch point's vertical offset by bumpFactor.
    final List<Offset> adjustedPoints = p.map((pt) {
      return Offset(pt.dx, pt.dy * bumpFactor);
    }).toList();

    final Path path = Path()
      ..moveTo(host.left, host.top)
      ..lineTo(host.left, host.bottom)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.right, host.top);
    for (final pt in adjustedPoints) {
      path.lineTo(guest.center.dx + pt.dx, guest.center.dy + pt.dy);
    }
    path.close();
    return path;
  }
}
