import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../models/book.dart';
import '../services/supabase_service.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _handling = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Book QR'),leading: IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    ),),
      body: Stack(
        children: [
          MobileScanner(onDetect: (capture) async {
            if (_handling) return;
            _handling = true;
            try {
              final code = capture.barcodes.isNotEmpty ? capture.barcodes.first.rawValue : null;
              if (code == null) return;
              final bookId = _extractBookId(code);
              if (bookId == null) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid QR')));
                }
                _handling = false;
                return;
              }
              final book = await SupabaseService.fetchBookById(bookId);
              if (book == null) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Book not found')));
                }
                _handling = false;
                return;
              }
              if (mounted) context.go('/book', extra: book);
            } finally {
              _handling = false;
            }
          }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)),
                child: const Text('Align QR within the frame', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _extractBookId(String raw) {
    // Accept either a bare UUID or a URL that ends with /book/{id}
    final uuidRegex = RegExp(r"[0-9a-fA-F-]{36}");
    final match = uuidRegex.firstMatch(raw);
    return match?.group(0);
  }
}