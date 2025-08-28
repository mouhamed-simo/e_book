import 'package:ebook_mvp/utils/app_theme.dart';
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
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await SupabaseService.init();
  runApp(const ProviderScope(child: EBookApp()));
}

class EBookApp extends StatelessWidget {
  const EBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/quiz',
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
            // final url =
            // "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
            final title = state.uri.queryParameters['title'] ?? 'Audio';
            // final title = "The Art of Mindful Living";
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
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
