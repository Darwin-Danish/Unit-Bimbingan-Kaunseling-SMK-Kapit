import 'package:flutter/material.dart';

class MoodAnimationController {
  // Singleton pattern
  static final MoodAnimationController _instance = MoodAnimationController._internal();
  factory MoodAnimationController() => _instance;
  MoodAnimationController._internal();

  // Animation controller
  AnimationController? _animationController;
  
  // Animation status
  bool _isVisible = true;
  bool get isVisible => _isVisible;

  // Initialize the controller
  void initialize(TickerProvider vsync) {
    _animationController?.dispose();
    _animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
  }

  // Toggle visibility with animation
  Future<void> toggleVisibility({bool? visible}) async {
    if (_animationController == null) return;
    
    final bool targetVisibility = visible ?? !_isVisible;
    
    if (targetVisibility == _isVisible) return;
    
    if (targetVisibility) {
      _animationController!.reverse();
    } else {
      _animationController!.forward();
    }
    
    _isVisible = targetVisibility;
  }

  // Hide the mood selector
  Future<void> hideMoodSelector() async {
    await toggleVisibility(visible: false);
  }

  // Show the mood selector
  Future<void> showMoodSelector() async {
    await toggleVisibility(visible: true);
  }

  // Get the animation value
  Animation<double> get animation => _animationController!;

  // Dispose the controller
  void dispose() {
    _animationController?.dispose();
    _animationController = null;
  }
}