import 'package:equatable/equatable.dart';

class Experience extends Equatable {
  final String id;
  final String company;
  final String position;
  final String location;
  final String type;
  final String startDate;
  final String? endDate;
  final bool current;
  final String logo;
  final String description;
  final List<String> responsibilities;
  final List<String> achievements;
  final List<String> technologies;
  final String website;

  const Experience({
    required this.id,
    required this.company,
    required this.position,
    required this.location,
    required this.type,
    required this.startDate,
    this.endDate,
    required this.current,
    required this.logo,
    required this.description,
    required this.responsibilities,
    required this.achievements,
    required this.technologies,
    required this.website,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'] as String,
      company: json['company'] as String,
      position: json['position'] as String,
      location: json['location'] as String,
      type: json['type'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
      current: json['current'] as bool,
      logo: json['logo'] as String,
      description: json['description'] as String,
      responsibilities: List<String>.from(json['responsibilities'] as List),
      achievements: List<String>.from(json['achievements'] as List),
      technologies: List<String>.from(json['technologies'] as List),
      website: json['website'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company': company,
      'position': position,
      'location': location,
      'type': type,
      'startDate': startDate,
      'endDate': endDate,
      'current': current,
      'logo': logo,
      'description': description,
      'responsibilities': responsibilities,
      'achievements': achievements,
      'technologies': technologies,
      'website': website,
    };
  }

  @override
  List<Object?> get props => [
    id,
    company,
    position,
    location,
    type,
    startDate,
    endDate,
    current,
    logo,
    description,
    responsibilities,
    achievements,
    technologies,
    website,
  ];
}

class Education extends Equatable {
  final String id;
  final String institution;
  final String degree;
  final String field;
  final String location;
  final String startDate;
  final String endDate;
  final String gpa;
  final String logo;
  final String description;
  final List<String> achievements;

  const Education({
    required this.id,
    required this.institution,
    required this.degree,
    required this.field,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.gpa,
    required this.logo,
    required this.description,
    required this.achievements,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'] as String,
      institution: json['institution'] as String,
      degree: json['degree'] as String,
      field: json['field'] as String,
      location: json['location'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      gpa: json['gpa'] as String,
      logo: json['logo'] as String,
      description: json['description'] as String,
      achievements: List<String>.from(json['achievements'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'institution': institution,
      'degree': degree,
      'field': field,
      'location': location,
      'startDate': startDate,
      'endDate': endDate,
      'gpa': gpa,
      'logo': logo,
      'description': description,
      'achievements': achievements,
    };
  }

  @override
  List<Object?> get props => [id, institution, degree, field, location, startDate, endDate, gpa, logo, description, achievements];
}

class Certification extends Equatable {
  final String id;
  final String name;
  final String issuer;
  final String date;
  final String credentialId;
  final String logo;
  final String url;

  const Certification({
    required this.id,
    required this.name,
    required this.issuer,
    required this.date,
    required this.credentialId,
    required this.logo,
    required this.url,
  });

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      id: json['id'] as String,
      name: json['name'] as String,
      issuer: json['issuer'] as String,
      date: json['date'] as String,
      credentialId: json['credentialId'] as String,
      logo: json['logo'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'issuer': issuer, 'date': date, 'credentialId': credentialId, 'logo': logo, 'url': url};
  }

  @override
  List<Object?> get props => [id, name, issuer, date, credentialId, logo, url];
}
