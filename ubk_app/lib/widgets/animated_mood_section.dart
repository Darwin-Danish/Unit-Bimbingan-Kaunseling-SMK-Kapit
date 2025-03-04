import 'package:flutter/material.dart';
import '../controllers/mood_animation_controller.dart';
import 'mood_selector.dart';

class AnimatedMoodSection extends StatefulWidget {
  final Function(String) onMoodSelected;

  const AnimatedMoodSection({
    Key? key,
    required this.onMoodSelected,
  }) : super(key: key);

  @override
  State<AnimatedMoodSection> createState() => _AnimatedMoodSectionState();
}

class _AnimatedMoodSectionState extends State<AnimatedMoodSection> with SingleTickerProviderStateMixin {
  late MoodAnimationController _controller;
  String _selectedMood = '';

  @override
  void initState() {
    super.initState();
    _controller = MoodAnimationController();
    _controller.initialize(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleMoodSelected(String mood) {
    setState(() {
      _selectedMood = mood;
    });
    widget.onMoodSelected(mood);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.animation,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mood prompt with fade and slide animation
            AnimatedOpacity(
              opacity: 1.0 - _controller.animation.value,
              duration: const Duration(milliseconds: 300),
              child: Transform.translate(
                offset: Offset(0, -20 * _controller.animation.value),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _selectedMood.isEmpty
                        ? const Text(
                            'How Do You Feel?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          )
                        : Row(
                            children: [
                              const Text(
                                'You feel: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                _selectedMood,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.refresh, color: Colors.white, size: 16),
                                onPressed: () {
                                  setState(() {
                                    _selectedMood = '';
                                  });
                                  _controller.showMoodSelector();
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                    Icon(
                      Icons.more_horiz,
                      color: Colors.white.withOpacity(0.7),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Mood selector with slide and fade animation
            ClipRect(
              child: AnimatedOpacity(
                opacity: 1.0 - _controller.animation.value,
                duration: const Duration(milliseconds: 300),
                child: SizeTransition(
                  sizeFactor: Tween<double>(
                    begin: 1.0,
                    end: 0.0,
                  ).animate(CurvedAnimation(
                    parent: _controller.animation,
                    curve: Curves.easeInOut,
                  )),
                  child: SizedBox(
                    height: 90,
                    child: MoodSelector(onMoodSelected: _handleMoodSelected),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}