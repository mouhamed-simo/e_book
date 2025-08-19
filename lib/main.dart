import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'models/book.dart';
import 'screens/audio_player_screen.dart';
import 'screens/book_details_screen.dart';
import 'screens/qr_scanner_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/reader_screen.dart';
import 'screens/splash_screen.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.init();
  runApp(const ProviderScope(child: EBookApp()));
}

class EBookApp extends StatelessWidget {
  const EBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/scan',
          builder: (context, state) => const QrScannerScreen(),
        ),
        GoRoute(
          path: '/book',
          builder: (context, state) {
            final book = state.extra as Book;
            return BookDetailsScreen(book: book);
          },
        ),
        GoRoute(
          path: '/reader',
          builder: (context, state) {
            final url = state.uri.queryParameters['url']!;
            return ReaderScreen(ebookUrl: url);
          },
        ),
        GoRoute(
          path: '/audio',
          builder: (context, state) {
            final url = state.uri.queryParameters['url']!;
            final title = state.uri.queryParameters['title'] ?? 'Audio';
            return AudioPlayerScreen(audioUrl: url, title: title);
          },
        ),
        GoRoute(
          path: '/quiz',
          builder: (context, state) {
            final book = state.extra as Book;
            return QuizScreen(book: book);
          },
        ),
      ],
    );

    return MaterialApp.router(
      title: 'E‑Book MVP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
