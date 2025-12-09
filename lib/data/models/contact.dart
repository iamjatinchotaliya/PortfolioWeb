import 'package:equatable/equatable.dart';

class ContactInfo extends Equatable {
  final FormConfig formConfig;
  final List<ContactMethod> contactMethods;
  final List<SocialLink> socialLinks;
  final Availability availability;

  const ContactInfo({
    required this.formConfig,
    required this.contactMethods,
    required this.socialLinks,
    required this.availability,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      formConfig: FormConfig.fromJson(json['formConfig'] as Map<String, dynamic>),
      contactMethods: (json['contactMethods'] as List)
          .map((method) => ContactMethod.fromJson(method as Map<String, dynamic>))
          .toList(),
      socialLinks: (json['socialLinks'] as List)
          .map((link) => SocialLink.fromJson(link as Map<String, dynamic>))
          .toList(),
      availability: Availability.fromJson(json['availability'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'formConfig': formConfig.toJson(),
      'contactMethods': contactMethods.map((method) => method.toJson()).toList(),
      'socialLinks': socialLinks.map((link) => link.toJson()).toList(),
      'availability': availability.toJson(),
    };
  }

  @override
  List<Object?> get props => [formConfig, contactMethods, socialLinks, availability];
}

class FormConfig extends Equatable {
  final bool enabled;
  final String email;
  final String subject;
  final String successMessage;
  final String errorMessage;

  const FormConfig({
    required this.enabled,
    required this.email,
    required this.subject,
    required this.successMessage,
    required this.errorMessage,
  });

  factory FormConfig.fromJson(Map<String, dynamic> json) {
    return FormConfig(
      enabled: json['enabled'] as bool,
      email: json['email'] as String,
      subject: json['subject'] as String,
      successMessage: json['successMessage'] as String,
      errorMessage: json['errorMessage'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'email': email,
      'subject': subject,
      'successMessage': successMessage,
      'errorMessage': errorMessage,
    };
  }

  @override
  List<Object?> get props => [enabled, email, subject, successMessage, errorMessage];
}

class ContactMethod extends Equatable {
  final String id;
  final String type;
  final String label;
  final String value;
  final String icon;
  final String link;
  final bool primary;

  const ContactMethod({
    required this.id,
    required this.type,
    required this.label,
    required this.value,
    required this.icon,
    required this.link,
    required this.primary,
  });

  factory ContactMethod.fromJson(Map<String, dynamic> json) {
    return ContactMethod(
      id: json['id'] as String,
      type: json['type'] as String,
      label: json['label'] as String,
      value: json['value'] as String,
      icon: json['icon'] as String,
      link: json['link'] as String,
      primary: json['primary'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'label': label,
      'value': value,
      'icon': icon,
      'link': link,
      'primary': primary,
    };
  }

  @override
  List<Object?> get props => [id, type, label, value, icon, link, primary];
}

class SocialLink extends Equatable {
  final String id;
  final String platform;
  final String username;
  final String url;
  final String icon;
  final String color;

  const SocialLink({
    required this.id,
    required this.platform,
    required this.username,
    required this.url,
    required this.icon,
    required this.color,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      id: json['id'] as String,
      platform: json['platform'] as String,
      username: json['username'] as String,
      url: json['url'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'platform': platform,
      'username': username,
      'url': url,
      'icon': icon,
      'color': color,
    };
  }

  @override
  List<Object?> get props => [id, platform, username, url, icon, color];
}

class Availability extends Equatable {
  final String status;
  final String message;
  final bool openToWork;
  final String preferredContact;
  final String responseTime;

  const Availability({
    required this.status,
    required this.message,
    required this.openToWork,
    required this.preferredContact,
    required this.responseTime,
  });

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      status: json['status'] as String,
      message: json['message'] as String,
      openToWork: json['openToWork'] as bool,
      preferredContact: json['preferredContact'] as String,
      responseTime: json['responseTime'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'openToWork': openToWork,
      'preferredContact': preferredContact,
      'responseTime': responseTime,
    };
  }

  @override
  List<Object?> get props => [status, message, openToWork, preferredContact, responseTime];
}
