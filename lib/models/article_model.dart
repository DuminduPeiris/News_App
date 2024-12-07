class Article {
  int? id;  // Optional id field for SQLite
  final String title;
  final String? description;
  final String url;
  final String urlToImage;
  final String? publishedAt;
  final String? author;
  final String? content;

  // Constructor for initializing the article fields
  Article({
    this.id,  // Optional id for database storage
    required this.title,
    this.description,
    required this.url,
    required this.urlToImage,
    this.publishedAt,
    this.author,
    this.content,
  });

  // Convert an Article object to a Map for SQLite storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,  // Include id field for SQLite
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'author': author,
      'content': content,
    };
  }

  // Create an Article object from a Map (e.g., SQLite query result)
  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'],  // Retrieve the id from map (useful for SQLite)
      title: map['title'],
      description: map['description'],
      url: map['url'],
      urlToImage: map['urlToImage'],
      publishedAt: map['publishedAt'],
      author: map['author'],
      content: map['content'],
    );
  }

  // Create an Article object from JSON data (useful for API responses)
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',  // Default to empty string if title is missing
      description: json['description'],
      url: json['url'] ?? '',  // Default to empty string if URL is missing
      urlToImage: json['urlToImage'] ?? '',  // Default to empty if no image URL
      publishedAt: json['publishedAt'],
      author: json['author'],
      content: json['content'],
    );
  }

  // Override equality operator to compare articles by title and URL
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Article &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          url == other.url;

  // Generate a hashCode based on title and URL to support efficient comparison
  @override
  int get hashCode => title.hashCode ^ url.hashCode;
}
