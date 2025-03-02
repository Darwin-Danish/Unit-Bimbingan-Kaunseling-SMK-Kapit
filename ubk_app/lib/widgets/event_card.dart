import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final Color color;
  final String startTime;
  final String endTime;
  final String? caption;

  const EventCard({
    Key? key,
    required this.title,
    required this.date,
    required this.location,
    required this.color,
    required this.startTime,
    required this.endTime,
    this.caption,
  }) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    final bool hasCaption = caption != null && caption!.isNotEmpty;
    return Container(
      width: 250,
      constraints: BoxConstraints(
        minHeight: hasCaption ? 170 : 140, // Smaller height when no caption
      ),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    location,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    '$startTime - $endTime',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (hasCaption) _buildCaptionSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCaptionSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
        ),
        child: Text(
          caption!,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[800],
            height: 1.4,
          ),
        ),
      ),
    );
  }
}