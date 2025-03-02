import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'widgets/mood_selector.dart';
import 'widgets/home_content.dart';
import 'qna_screen.dart';
import 'package:ubk_app/booking_screen.dart'; // for the FAB navigation
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Bottom nav items indices:
  // 0: Home, 1: Docs, 2: Q&A, 3: Bot
  int _selectedIndex = 0;
  String _selectedMood = '';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
        // Blue header section
        Container(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
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
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _getCurrentDate(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Search bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Mood prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'How Do You Feel?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    Icons.more_horiz,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Mood selector widget
              MoodSelector(onMoodSelected: _onMoodSelected),
            ],
          ),
        ),
        // White content area with scrolling
        Expanded(
          child: HomeContent(),
        ),
      ],
    );
  }

  // Build a placeholder for the Docs screen
  Widget _buildDocsScreen() {
    return const Center(
      child: Text(
        'Docs Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  // Build the Q&A screen (from qua.dart / qna_screen.dart)
  Widget _buildQAScreen() {
    return const QnAScreen();
  }

  // Build a placeholder for the Bot screen
  Widget _buildBotScreen() {
    return const Center(
      child: Text(
        'Bot Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
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
    return Scaffold(
      body: _buildBody(),
      // Floating Action Button remains for BookingScreen
      floatingActionButton: FloatingActionButton(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // Updated bottom navigation bar with two groups and gap for the FAB.
      bottomNavigationBar: BottomAppBar(
        notchMargin: 10,
        shape: const CircularNotch(),
        color: Colors.white,
        elevation: 10,
        child: SizedBox(
          height: 60,
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
              const SizedBox(width: 60), // Gap reserved for the FAB
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

// Custom notch shape for the bottom app bar
class CircularNotch extends NotchedShape {
  const CircularNotch();

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest == null || !host.overlaps(guest)) {
      return Path()..addRect(host);
    }

    final double notchRadius = guest.width / 2;
    const double s1 = 15;
    const double s2 = 10;
    final double r = notchRadius;
    final double a = -1.0 * r - s2;
    final double b = host.top - guest.center.dy;
    final double n2 = math.sqrt(b * b * r * r * (a * a + b * b - r * r));
    final double p2xA = ((a * r * r) - n2) / (a * a + b * b);
    final double p2xB = ((a * r * r) + n2) / (a * a + b * b);
    final double p2yA = math.sqrt(r * r - p2xA * p2xA);
    final double p2yB = math.sqrt(r * r - p2xB * p2xB);
    final List<Offset> p = List<Offset>.filled(6, Offset.zero);
    p[0] = Offset(a - s1, b);
    p[1] = Offset(a, b);
    final double cX = p2xB;
    final double cY = -p2yB;
    p[2] = Offset(cX, cY);
    p[3] = Offset(-cX, cY);
    p[4] = Offset(-a, b);
    p[5] = Offset(-a + s1, b);
    final Path path = Path()
      ..moveTo(host.left, host.top)
      ..lineTo(host.left, host.bottom)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.right, host.top);
    for (int i = 0; i < p.length; i += 1) {
      final Offset pi = p[i];
      path.lineTo(guest.center.dx + pi.dx, guest.center.dy + pi.dy);
    }
    path.close();
    return path;
  }
}
