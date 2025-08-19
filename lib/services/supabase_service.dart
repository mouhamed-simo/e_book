import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/book.dart';

class SupabaseService {
  static Future<void> init() async {
    await Supabase.initialize(
      url: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://pjbjmlndfeslhssbotwh.supabase.co'),
      anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBqYmptbG5kZmVzbGhzc2JvdHdoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUwODI3NDUsImV4cCI6MjA3MDY1ODc0NX0.4aN8A0LUFZ-oXGHCHgCMm6zwvnap36T4Ia4bI5_yDYc'),
    );
  }

  static SupabaseClient get _client => Supabase.instance.client;

  static Future<Book?> fetchBookById(String bookId) async {
    final res = await _client.from('books').select().eq('id', bookId).maybeSingle();
    if (res == null) return null;
    return Book.fromMap(res);
  }
}