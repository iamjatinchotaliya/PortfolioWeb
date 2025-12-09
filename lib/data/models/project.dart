import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String longDescription;
  final String image;
  final List<String> images;
  final String category;
  final List<String> technologies;
  final List<String> features;
  final String github;
  final String liveUrl;
  final String videoUrl;
  final String model3d;
  final String status;
  final String duration;
  final String team;
  final String role;
  final bool featured;
  final int order;

  const Project({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.longDescription,
    required this.image,
    required this.images,
    required this.category,
    required this.technologies,
    required this.features,
    required this.github,
    required this.liveUrl,
    required this.videoUrl,
    required this.model3d,
    required this.status,
    required this.duration,
    required this.team,
    required this.role,
    required this.featured,
    required this.order,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      description: json['description'] as String,
      longDescription: json['longDescription'] as String,
      image: json['image'] as String,
      images: List<String>.from(json['images'] as List),
      category: json['category'] as String,
      technologies: List<String>.from(json['technologies'] as List),
      features: List<String>.from(json['features'] as List),
      github: json['github'] as String,
      liveUrl: json['liveUrl'] as String,
      videoUrl: json['videoUrl'] as String,
      model3d: json['model3d'] as String,
      status: json['status'] as String,
      duration: json['duration'] as String,
      team: json['team'] as String,
      role: json['role'] as String,
      featured: json['featured'] as bool,
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'longDescription': longDescription,
      'image': image,
      'images': images,
      'category': category,
      'technologies': technologies,
      'features': features,
      'github': github,
      'liveUrl': liveUrl,
      'videoUrl': videoUrl,
      'model3d': model3d,
      'status': status,
      'duration': duration,
      'team': team,
      'role': role,
      'featured': featured,
      'order': order,
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    description,
    longDescription,
    image,
    images,
    category,
    technologies,
    features,
    github,
    liveUrl,
    videoUrl,
    model3d,
    status,
    duration,
    team,
    role,
    featured,
    order,
  ];
}
