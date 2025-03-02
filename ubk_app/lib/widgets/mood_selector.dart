import 'package:flutter/material.dart';

class MoodSelector extends StatefulWidget {
  final Function(String) onMoodSelected;

  const MoodSelector({Key? key, required this.onMoodSelected}) : super(key: key);

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  String _selectedMood = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildMoodOption('Badly', '😔'),
        _buildMoodOption('Fine', '🙂'),
        _buildMoodOption('Well', '😄'),
        _buildMoodOption('Excellent', '😃'),
      ],
    );
  }

  Widget _buildMoodOption(String mood, String emoji) {
    final isSelected = _selectedMood == mood;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMood = mood;
        });
        widget.onMoodSelected(mood);
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected 
                  ? Colors.white.withOpacity(0.3) 
                  : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            mood,
            style: TextStyle(
              color: Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}