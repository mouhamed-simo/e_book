import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/book.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static Future<void> init() async {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    );
  }

  static SupabaseClient get _client => Supabase.instance.client;

  static Future<Book?> fetchBookById(String bookId) async {
    final res = await _client.from('books').select().eq('id', bookId).maybeSingle();
    if (res == null) return null;
    return Book.fromMap(res);
  }
}