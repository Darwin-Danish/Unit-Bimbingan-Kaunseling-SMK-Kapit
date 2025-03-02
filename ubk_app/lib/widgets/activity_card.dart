import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String time;
  final String date;
  final String counselorName;
  final bool isAvailable;
  final String status; // "Scheduled", "Completed", "Cancelled"

  const ActivityCard({
    Key? key,
    required this.title,
    required this.time,
    required this.date,
    required this.counselorName,
    this.icon = Icons.calendar_today,
    this.color = Colors.blue,
    this.isAvailable = true,
    this.status = "Scheduled",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isAvailable) {
      return _buildNoAppointmentCard();
    }

    // Get screen width to make layout adaptive
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                // Left side - Time indicator with adaptive width
                Container(
                  width: isSmallScreen ? 50 : 60,
                  padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 8 : 12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 10 : 12,
                          color: color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: isSmallScreen ? 10 : 16),

                // Middle - Appointment details (without description)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Counselor: $counselorName",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 14,
                          color: Colors.black87,
                        ),
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Right - Status indicator with adaptive padding
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8 : 12, 
                    vertical: isSmallScreen ? 4 : 6
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor().withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: _getStatusColor(),
                      fontWeight: FontWeight.w600,
                      fontSize: isSmallScreen ? 10 : 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Reminder notice
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16, 
              vertical: isSmallScreen ? 8 : 10
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.notifications_active_outlined,
                  size: isSmallScreen ? 14 : 16,
                  color: color,
                ),
                SizedBox(width: isSmallScreen ? 6 : 8),
                Expanded(
                  child: Text(
                    "Reminder set for 30 minutes before",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 11 : 12,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoAppointmentCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(
                Icons.event_busy,
                size: 40,
                color: Colors.grey,
              ),
              SizedBox(height: 8),
              Text(
                "No appointments scheduled",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case "scheduled":
        return Colors.blue;
      case "completed":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}