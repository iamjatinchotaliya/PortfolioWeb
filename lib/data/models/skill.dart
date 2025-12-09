import 'package:equatable/equatable.dart';

class SkillCategory extends Equatable {
  final String name;
  final String icon;
  final List<Skill> skills;

  const SkillCategory({required this.name, required this.icon, required this.skills});

  factory SkillCategory.fromJson(Map<String, dynamic> json) {
    return SkillCategory(
      name: json['name'] as String,
      icon: json['icon'] as String,
      skills: (json['skills'] as List).map((skill) => Skill.fromJson(skill as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'icon': icon, 'skills': skills.map((skill) => skill.toJson()).toList()};
  }

  @override
  List<Object?> get props => [name, icon, skills];
}

class Skill extends Equatable {
  final String name;
  final int level;
  final String icon;
  final String color;

  const Skill({required this.name, required this.level, required this.icon, required this.color});

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(name: json['name'] as String, level: json['level'] as int, icon: json['icon'] as String, color: json['color'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'level': level, 'icon': icon, 'color': color};
  }

  @override
  List<Object?> get props => [name, level, icon, color];
}
