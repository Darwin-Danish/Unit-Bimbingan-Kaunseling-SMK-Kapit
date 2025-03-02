import 'package:flutter/material.dart';
import 'package:ubk_app/document_viewer.dart';

class DocumentModel {
  final String title;
  final String details;
  final IconData icon;
  final Color iconColor;
  final String documentPath;
  final String category;

  DocumentModel({
    required this.title,
    required this.details,
    required this.icon,
    required this.iconColor,
    required this.documentPath,
    required this.category,
  });
}

class DocsScreen extends StatelessWidget {
  DocsScreen({Key? key}) : super(key: key);

  // Sample list of documents with assigned categories
  final List<DocumentModel> documents = [
    DocumentModel(
      title: 'Study Tips',
      details: 'PDF • 1.2 MB • Mar 5, 2023',
      icon: Icons.picture_as_pdf,
      iconColor: Colors.red.shade400,
      documentPath: 'assets/docs/example.pdf',
      category: 'Academic',
    ),
    DocumentModel(
      title: 'Scholarship Opportunities',
      details: 'PDF • 3.5 MB • Apr 10, 2023',
      icon: Icons.picture_as_pdf,
      iconColor: Colors.red.shade400,
      documentPath: 'assets/docs/example.pdf',
      category: 'Academic',
    ),
    DocumentModel(
      title: 'School Calendar',
      details: 'JPG • 0.9 MB • Jan 5, 2023',
      icon: Icons.image,
      iconColor: Colors.green.shade400,
      documentPath: 'assets/images/counselor4.png',
      category: 'Academic',
    ),
    DocumentModel(
      title: 'Career Planning Guide',
      details: 'PDF • 2.4 MB • Feb 15, 2023',
      icon: Icons.picture_as_pdf,
      iconColor: Colors.red.shade400,
      documentPath: 'assets/docs/example.pdf',
      category: 'Career',
    ),
    DocumentModel(
      title: 'Mental Health Poster',
      details: 'JPG • 1.8 MB • Jan 30, 2023',
      icon: Icons.image,
      iconColor: Colors.green.shade400,
      documentPath: 'assets/images/counselor1.png',
      category: 'Mental Health',
    ),
  ];

  // List of all categories to display
  final List<String> categories = [
    'Academic',
    'Personal',
    'Career',
    'Social',
    'Mental Health',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: ListView(
          children: [
            // Header for the grouped view
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                'Documents by Category',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Build a section for each category
            ...categories.map((category) {
              // Filter documents for the current category
              final List<DocumentModel> docsForCategory =
                  documents.where((doc) => doc.category == category).toList();
              return _buildCategorySection(context, category, docsForCategory);
            }).toList(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Builds a section for each category with its list of documents or a no-data message.
  Widget _buildCategorySection(
      BuildContext context, String category, List<DocumentModel> docs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          docs.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'No documents available for $category.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              : Column(
                  children: docs
                      .map((doc) => _buildDocumentListItem(context, doc))
                      .toList(),
                ),
          const Divider(),
        ],
      ),
    );
  }

  // Build each document list item using the provided document data.
  Widget _buildDocumentListItem(BuildContext context, DocumentModel doc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: doc.iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            doc.icon,
            color: doc.iconColor,
            size: 28,
          ),
        ),
        title: Text(
          doc.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          doc.details,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DocumentViewer(
                title: doc.title,
                filePath: doc.documentPath,
                fileType: doc.documentPath.endsWith('.pdf') ? 'PDF' : 'IMAGE',
              ),
            ),
          );
        },
      ),
    );
  }
}
