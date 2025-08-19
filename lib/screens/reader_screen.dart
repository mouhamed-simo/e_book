import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReaderScreen extends StatelessWidget {
  final String ebookUrl;
  const ReaderScreen({super.key, required this.ebookUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reader')),
      body: SfPdfViewer.network(ebookUrl),
    );
  }
}