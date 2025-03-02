import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Q&A Forum',
      debugShowCheckedModeBanner: false,
      home: const QnAScreen(),
    );
  }
}

class QnAScreen extends StatefulWidget {
  const QnAScreen({Key? key}) : super(key: key);

  @override
  State<QnAScreen> createState() => _QnAScreenState();
}

class _QnAScreenState extends State<QnAScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final TextEditingController _questionController = TextEditingController();

  // Categories for the dropdown
  final List<String> _categories = [
    'Academic',
    'Personal',
    'Career',
    'Social',
    'Mental Health',
    'Other'
  ];
  String _selectedCategory = 'Academic';

  // Sample Q&A data - in a real app, this would come from a database
  final List<Map<String, dynamic>> _qnaList = [
    {
      'question': 'Why do people clear the screen multiple times when using a calculator?',
      'answer':
          'This is often a habit formed from uncertainty. People want to ensure the calculator is truly reset before starting a new calculation, even though a single clear is sufficient.',
      'category': 'Psychology',
      'upvotes': 42,
      'views': 128,
      'author': 'Dr. Sarah Chen',
      'authorRole': 'Cognitive Psychologist'
    },
    {
      'question': 'How can I manage stress during exam periods?',
      'answer':
          'Establish a study routine, take regular breaks, practice mindfulness, ensure adequate sleep, and maintain physical activity. Remember that some stress is normal, but excessive stress can be managed with proper techniques.',
      'category': 'Mental Health',
      'upvotes': 78,
      'views': 256,
      'author': 'Mark Johnson',
      'authorRole': 'School Counselor'
    },
    {
      'question': 'What career paths are available for students interested in technology?',
      'answer':
          'Technology offers diverse paths including software development, cybersecurity, data science, UX/UI design, IT support, cloud engineering, AI research, and more. Each requires different skills and education, but all are in high demand.',
      'category': 'Career',
      'upvotes': 65,
      'views': 189,
      'author': 'Tan Wei Ling',
      'authorRole': 'Tech Industry Advisor'
    },
    {
      'question': 'How do I improve my study focus and concentration?',
      'answer':
          'Create a dedicated study environment, use the Pomodoro technique (25 minutes study, 5 minutes break), minimize distractions, stay hydrated, and consider background music without lyrics. Regular exercise also improves cognitive function.',
      'category': 'Education',
      'upvotes': 91,
      'views': 312,
      'author': 'Prof. Ahmad Razak',
      'authorRole': 'Education Specialist'
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _upvoteQuestion(int index) {
    setState(() {
      _qnaList[index]['upvotes']++;
    });
  }

  // Plus button functionality: show a modern popup dialog for anonymous question submission.
  void _showAddQuestionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4))
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with icon and title
                  Row(
                    children: const [
                      Icon(Icons.question_mark, color: Colors.blue, size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Submit Anonymous Question',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Introduction text
                  const Text(
                    'This feature is designed to help students who feel shy about asking questions face-to-face with a counselor. Ask your question anonymously and get the support you need.',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  // Warning in a red container
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: const Text(
                      'Warning: Please do not submit any inappropriate content. All submissions will be reviewed by PRS and Counselors.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Category Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon:
                          const Icon(Icons.category, color: Colors.blue),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  // Question TextField
                  TextField(
                    controller: _questionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Your Question',
                      hintText: 'Type your question here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Privacy reminder in its own container
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.privacy_tip,
                            size: 16, color: Colors.blue),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Anonymous Submission: Your name will not be displayed with your question',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (_questionController.text.isNotEmpty) {
                            _showSubmissionConfirmation();
                          }
                        },
                        child: const Text(
                          'Submit Question',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Show confirmation after question submission.
  void _showSubmissionConfirmation() {
    Navigator.of(context).pop(); // Close the question dialog

    // Clear the text fields
    _questionController.clear();
    setState(() {
      _selectedCategory = _categories.first;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Question Submitted',
                  style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thank you for your submission!',
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your question will be reviewed by our PRS and Counselors and will be responded to soon. It will appear on the forum after approval.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Remember: Your identity remains anonymous.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: const Text(
          'Q&A Forum',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          // Only the plus button for submitting a new question
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black54),
            onPressed: _showAddQuestionDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Swipe instruction
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.swipe, size: 18, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Swipe left/right to check more',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Q&A Cards
          Expanded(
            child: _qnaList.isEmpty
                ? const Center(child: Text('No questions available'))
                : PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _qnaList.length + 1, // +1 for the end card
                    itemBuilder: (context, index) {
                      if (index == _qnaList.length) {
                        return _buildEndCard();
                      }
                      return _buildQnACard(_qnaList[index], index);
                    },
                  ),
          ),
          // Page indicator
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _qnaList.length + 1,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Colors.blue
                        : Colors.grey.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQnACard(Map<String, dynamic> qna, int index) {
    final Color cardColor = [
      const Color(0xFF4A80F0),
      const Color(0xFFFF5673),
      const Color(0xFF19B38D),
      const Color(0xFFFFB946),
    ][index % 4];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cardColor,
                cardColor.withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category tag
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '#${qna['category']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              // Question
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Text(
                  qna['question'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    height: 1.3,
                  ),
                ),
              ),
              // Answer section with white background
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Author info
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: cardColor.withOpacity(0.1),
                            child: Text(
                              qna['author'].toString().substring(0, 1),
                              style: TextStyle(
                                color: cardColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                qna['author'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                qna['authorRole'],
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Answer text
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            qna['answer'],
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      // Stats and upvote button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.remove_red_eye_outlined,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '${qna['views']} views',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => _upvoteQuestion(index),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: cardColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_upward,
                                    size: 16,
                                    color: cardColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${qna['upvotes']}',
                                    style: TextStyle(
                                      color: cardColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEndCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.check_circle_outline,
              size: 60,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "You've reached the end!",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "That's all the questions we have for now. Check back later for more!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              _pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text("Start Over"),
          ),
        ],
      ),
    );
  }
}
