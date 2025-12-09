import 'package:equatable/equatable.dart';

class BlogPost extends Equatable {
  final String id;
  final String title;
  final String slug;
  final String excerpt;
  final String content;
  final String coverImage;
  final String author;
  final String authorAvatar;
  final String category;
  final List<String> tags;
  final String publishDate;
  final String readTime;
  final int views;
  final int likes;
  final bool featured;
  final bool published;

  const BlogPost({
    required this.id,
    required this.title,
    required this.slug,
    required this.excerpt,
    required this.content,
    required this.coverImage,
    required this.author,
    required this.authorAvatar,
    required this.category,
    required this.tags,
    required this.publishDate,
    required this.readTime,
    required this.views,
    required this.likes,
    required this.featured,
    required this.published,
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      excerpt: json['excerpt'] as String,
      content: json['content'] as String,
      coverImage: json['coverImage'] as String,
      author: json['author'] as String,
      authorAvatar: json['authorAvatar'] as String,
      category: json['category'] as String,
      tags: List<String>.from(json['tags'] as List),
      publishDate: json['publishDate'] as String,
      readTime: json['readTime'] as String,
      views: json['views'] as int,
      likes: json['likes'] as int,
      featured: json['featured'] as bool,
      published: json['published'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'excerpt': excerpt,
      'content': content,
      'coverImage': coverImage,
      'author': author,
      'authorAvatar': authorAvatar,
      'category': category,
      'tags': tags,
      'publishDate': publishDate,
      'readTime': readTime,
      'views': views,
      'likes': likes,
      'featured': featured,
      'published': published,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        slug,
        excerpt,
        content,
        coverImage,
        author,
        authorAvatar,
        category,
        tags,
        publishDate,
        readTime,
        views,
        likes,
        featured,
        published,
      ];
}
