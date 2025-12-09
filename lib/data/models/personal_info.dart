import 'package:equatable/equatable.dart';

class PersonalInfo extends Equatable {
  final String name;
  final String title;
  final String tagline;
  final String bio;
  final String email;
  final String phone;
  final String location;
  final String avatar;
  final String resume;
  final String availability;
  final SocialLinks social;
  final List<Stat> stats;

  const PersonalInfo({
    required this.name,
    required this.title,
    required this.tagline,
    required this.bio,
    required this.email,
    required this.phone,
    required this.location,
    required this.avatar,
    required this.resume,
    required this.availability,
    required this.social,
    required this.stats,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      name: json['name'] as String,
      title: json['title'] as String,
      tagline: json['tagline'] as String,
      bio: json['bio'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      location: json['location'] as String,
      avatar: json['avatar'] as String,
      resume: json['resume'] as String,
      availability: json['availability'] as String,
      social: SocialLinks.fromJson(json['social'] as Map<String, dynamic>),
      stats: (json['stats'] as List)
          .map((stat) => Stat.fromJson(stat as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'title': title,
      'tagline': tagline,
      'bio': bio,
      'email': email,
      'phone': phone,
      'location': location,
      'avatar': avatar,
      'resume': resume,
      'availability': availability,
      'social': social.toJson(),
      'stats': stats.map((stat) => stat.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        name,
        title,
        tagline,
        bio,
        email,
        phone,
        location,
        avatar,
        resume,
        availability,
        social,
        stats,
      ];
}

class SocialLinks extends Equatable {
  final String github;
  final String linkedin;
  final String twitter;
  final String dribbble;
  final String medium;
  final String instagram;

  const SocialLinks({
    required this.github,
    required this.linkedin,
    required this.twitter,
    required this.dribbble,
    required this.medium,
    required this.instagram,
  });

  factory SocialLinks.fromJson(Map<String, dynamic> json) {
    return SocialLinks(
      github: json['github'] as String,
      linkedin: json['linkedin'] as String,
      twitter: json['twitter'] as String,
      dribbble: json['dribbble'] as String,
      medium: json['medium'] as String,
      instagram: json['instagram'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'github': github,
      'linkedin': linkedin,
      'twitter': twitter,
      'dribbble': dribbble,
      'medium': medium,
      'instagram': instagram,
    };
  }

  @override
  List<Object?> get props => [github, linkedin, twitter, dribbble, medium, instagram];
}

class Stat extends Equatable {
  final String label;
  final String value;
  final String icon;

  const Stat({
    required this.label,
    required this.value,
    required this.icon,
  });

  factory Stat.fromJson(Map<String, dynamic> json) {
    return Stat(
      label: json['label'] as String,
      value: json['value'] as String,
      icon: json['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'icon': icon,
    };
  }

  @override
  List<Object?> get props => [label, value, icon];
}
