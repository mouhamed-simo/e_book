class Book {
  final String id;
  final String title;
  final String? author;
  final String summary;
  final String? coverUrl;
  final String? ebookUrl;
  final String? audioUrl;

  Book({
    required this.id,
    required this.title,
    required this.summary,
    this.author,
    this.coverUrl,
    this.ebookUrl,
    this.audioUrl,
  });

  factory Book.fromMap(Map<String, dynamic> m) => Book(
        id: m['id'] as String,
        title: m['title'] as String,
        author: m['author'] as String?,
        summary: m['summary'] as String,
        coverUrl: m['cover_url'] as String?,
        ebookUrl: m['ebook_url'] as String?,
        audioUrl: m['audio_url'] as String?,
      );
}