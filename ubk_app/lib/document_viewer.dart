import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:async';

class DocumentViewer extends StatefulWidget {
  final String title;
  final String filePath;
  final String fileType;

  const DocumentViewer({
    Key? key,
    required this.title,
    required this.filePath,
    required this.fileType,
  }) : super(key: key);

  @override
  State<DocumentViewer> createState() => _DocumentViewerState();
}

class _DocumentViewerState extends State<DocumentViewer> {
  String? _localPath;
  bool _isLoading = true;
  int _totalPages = 0;
  int _currentPage = 0;
  PDFViewController? _pdfViewController;

  @override
  void initState() {
    super.initState();
    if (widget.fileType == 'PDF') {
      _loadPdfFile();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadPdfFile() async {
    try {
      final ByteData data = await rootBundle.load(widget.filePath);
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = '${tempDir.path}/${widget.title.replaceAll(' ', '_')}.pdf';
      final File tempFile = File(tempPath);
      await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);

      setState(() {
        _localPath = tempPath;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          if (widget.fileType == 'PDF' && !_isLoading)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                // Implement share functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share functionality coming soon')),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () {
              // Implement download functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Download functionality coming soon')),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _buildDocumentView(),
      bottomNavigationBar: widget.fileType == 'PDF' && !_isLoading && _totalPages > 0
          ? _buildPdfControls()
          : null,
    );
  }

  Widget _buildDocumentView() {
    if (widget.fileType == 'PDF') {
      if (_localPath == null) {
        return const Center(
          child: Text('Error loading PDF file'),
        );
      }

      return PDFView(
        filePath: _localPath!,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: true,
        pageFling: true,
        pageSnap: true,
        defaultPage: _currentPage,
        fitPolicy: FitPolicy.BOTH,
        preventLinkNavigation: false,
        onRender: (pages) {
          setState(() {
            _totalPages = pages!;
          });
        },
        onError: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        },
        onPageError: (page, error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error on page $page: $error')),
          );
        },
        onViewCreated: (PDFViewController pdfViewController) {
          setState(() {
            _pdfViewController = pdfViewController;
          });
        },
        onPageChanged: (int? page, int? total) {
          if (page != null) {
            setState(() {
              _currentPage = page;
            });
          }
        },
      );
    } else {
      // Image viewer
      return Container(
        color: Colors.black,
        child: PhotoView(
          imageProvider: AssetImage(widget.filePath),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
          backgroundDecoration: const BoxDecoration(color: Colors.black),
          loadingBuilder: (context, event) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorBuilder: (context, error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Error loading image',
                  style: TextStyle(color: Colors.white.withOpacity(0.8)),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildPdfControls() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: _currentPage > 0
                ? () {
                    _pdfViewController?.setPage(_currentPage - 1);
                  }
                : null,
          ),
          Text(
            'Page ${_currentPage + 1} of $_totalPages',
            style: const TextStyle(fontSize: 16),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: _currentPage < _totalPages - 1
                ? () {
                    _pdfViewController?.setPage(_currentPage + 1);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}