class Post {
  final String author;
  final String title;

  Post({
    required this.author,
    required this.title,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      author: json['author'] ?? 'Unknown Author',
      title: json['title'] ?? 'No Title',
    );
  }
}
