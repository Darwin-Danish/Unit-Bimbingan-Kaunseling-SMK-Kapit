import 'package:flutter/material.dart';
import 'activity_card.dart';
import 'event_card.dart';
import 'resource_card.dart';
import 'quote_card.dart';
import 'popular_topics_card.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Quote of the Day header
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'Quote Of The Day',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Quote of the Day
            const QuoteCard(
              quote: "Believe you can and you're halfway there.",
              author: "Theodore Roosevelt",
            ),

            const SizedBox(height: 20),

            // 2. Upcoming Events section
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'Upcoming Events',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Event cards
            SizedBox(
              height: 220, // Increased height to accommodate descriptions
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  EventCard(
                    title: 'Career Day',
                    date: 'Feb 15, 2024',
                    location: 'School Hall',
                    color: Colors.blue,
                    startTime: '9:00 AM',
                    endTime: '3:00 PM',
                    caption: '',
                  ),
                  const SizedBox(width: 12),
                  EventCard(
                    title: 'Counseling Workshop',
                    date: 'Mar 5, 2024',
                    location: 'Room 101',
                    color: Colors.green,
                    startTime: '10:00 AM',
                    endTime: '12:00 PM',
                    caption: 'Interactive workshop on stress management techniques.',
                  ),
                  const SizedBox(width: 12),
                  EventCard(
                    title: 'Parent-Teacher Meeting',
                    date: 'Mar 20, 2024',
                    location: 'School Hall',
                    color: Colors.orange,
                    startTime: '2:00 PM',
                    endTime: '5:00 PM',
                    caption: 'Discuss student progress and development with teachers.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

const Padding(
  padding: EdgeInsets.symmetric(vertical: 15),
  child: Text(
    'Upcoming Appointments',
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
),

// Activity cards (appointments)
ActivityCard(
  title: 'Career Guidance Session',
  time: '10:00 AM',
  date: 'Feb 15',
  counselorName: 'Ms. Sarah Wong',
  icon: Icons.person,
  color: Colors.blue,
  status: 'Scheduled',
),
const SizedBox(height: 10),
ActivityCard(
  title: 'Group Counseling',
  time: '2:30 PM',
  date: 'Feb 18',
  counselorName: 'Mr. David Tan',
  color: Colors.green,
  icon: Icons.groups,
  status: 'Scheduled',
),
            const SizedBox(height: 20),

            // 4. Popular Q&A section
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'Popular Q&A',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Popular Q&A cards
            PopularQnACard(
              qnaList: [
                {
                  'question': 'What is counseling?',
                  'answer': 'Counseling is a process of talking about and working through personal problems with a trained professional. It can help you understand your feelings, behaviors, and situations better, leading to improved mental health and well-being.'
                },
                {
                  'question': 'How can I manage stress?',
                  'answer': 'Some effective ways to manage stress include practicing relaxation techniques like deep breathing or meditation, regular exercise, maintaining a healthy diet, getting enough sleep, and talking to friends or a counselor about your concerns.'
                },
                {
                  'question': 'What are some study skills for exams?',
                  'answer': 'Effective study skills include creating a study schedule, using active recall techniques, taking breaks, staying organized, and practicing past exam questions. It\'s also important to find a study method that works best for you, such as visual aids or group study sessions.'
                },
              ],
            ),

            const SizedBox(height: 20),

            // 5. Self-Help Resources section
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'Self-Help Resources',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Resource cards
            ResourceCard(
              title: 'Stress Management Guide',
              description: 'Learn effective techniques to manage stress',
              icon: Icons.menu_book,
              color: Colors.blue.shade100,
              onTap: () {},
            ),
            const SizedBox(height: 10),
            ResourceCard(
              title: 'Daily Affirmations',
              description: 'Positive statements to improve your mindset',
              icon: Icons.favorite,
              color: Colors.pink.shade100,
              onTap: () {},
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}