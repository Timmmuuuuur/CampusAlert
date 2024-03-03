class BlogPost {
  final String title;
  final String content;

  BlogPost({required this.title, required this.content});

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      title: json['title'],
      content: json['content'],
    );
  }
}
