import '../models/blog_post.dart';
import '../models/contact.dart';
import '../models/experience.dart';
import '../models/personal_info.dart';
import '../models/project.dart';
import '../models/skill.dart';

/// Adapts the Python API's public response to the portfolio's presentation models.
/// Fields that the API does not provide remain empty instead of using demo data.
class PortfolioApiMapper {
  static PersonalInfo personalInfo(
    Map<String, dynamic> portfolio,
    Uri apiBaseUrl,
  ) {
    final profile = portfolio['profile'] as Map<String, dynamic>;
    final social = <String, String>{
      for (final link in _records(portfolio, 'social_links'))
        (link['platform'] as String).toLowerCase(): link['url'] as String,
    };
    final years = profile['years_experience'] as num?;
    return PersonalInfo(
      name: profile['name'] as String,
      title: profile['headline'] as String,
      tagline: '',
      bio: profile['bio'] as String,
      email: _text(profile['email']),
      phone: _text(profile['phone']),
      location: profile['location'] as String,
      avatar: resolveUrl(profile['photo_url'] as String?, apiBaseUrl),
      resume: resolveUrl(profile['resume_url'] as String?, apiBaseUrl),
      availability: _availability(profile),
      social: SocialLinks(
        github: social['github'] ?? '',
        linkedin: social['linkedin'] ?? '',
        twitter: social['twitter'] ?? social['x'] ?? '',
        dribbble: social['dribbble'] ?? '',
        medium: social['medium'] ?? '',
        instagram: social['instagram'] ?? '',
      ),
      stats: [
        if (years != null)
          Stat(label: 'Years Experience', value: _number(years), icon: 'work'),
        Stat(
          label: 'Projects',
          value: _records(portfolio, 'projects').length.toString(),
          icon: 'code',
        ),
        Stat(
          label: 'Skills',
          value: _records(portfolio, 'skills').length.toString(),
          icon: 'code',
        ),
      ],
    );
  }

  static List<SkillCategory> skills(Map<String, dynamic> portfolio) {
    final categories = <String, List<Skill>>{};
    for (final item in _records(portfolio, 'skills')) {
      final category = item['category'] as String;
      categories
          .putIfAbsent(category, () => [])
          .add(
            Skill(
              name: item['name'] as String,
              // The backend lists skills but does not quantify proficiency.
              level: 0,
              icon: 'code',
              color: '',
            ),
          );
    }
    return [
      for (final entry in categories.entries)
        SkillCategory(name: entry.key, icon: 'code', skills: entry.value),
    ];
  }

  static List<Project> projects(
    Map<String, dynamic> portfolio,
    Uri apiBaseUrl,
  ) {
    return [
      for (final item in _records(portfolio, 'projects'))
        Project(
          id: item['id'].toString(),
          title: item['title'] as String,
          subtitle: '',
          description: item['summary'] as String,
          longDescription: item['description'] as String,
          image: resolveUrl(item['image_url'] as String?, apiBaseUrl),
          images: [
            if (_text(item['image_url']).isNotEmpty)
              resolveUrl(item['image_url'] as String?, apiBaseUrl),
          ],
          category: 'Projects',
          technologies: [
            for (final skill in _records(item, 'skills'))
              skill['name'] as String,
          ],
          features: const [],
          github: _text(item['repository_url']),
          liveUrl: _text(item['demo_url']),
          playStoreUrl: _text(item['play_store_url']),
          appStoreUrl: _text(item['app_store_url']),
          videoUrl: '',
          model3d: '',
          status: '',
          duration: '',
          team: '',
          role: '',
          featured: item['featured'] as bool,
          order: item['display_order'] as int,
        ),
    ];
  }

  static List<Experience> experience(Map<String, dynamic> portfolio) {
    return [
      for (final item in _records(portfolio, 'experiences'))
        Experience(
          id: item['id'].toString(),
          company: item['company'] as String,
          position: item['role'] as String,
          location: item['location'] as String,
          type: '',
          startDate: item['start_month'] as String,
          endDate: item['end_month'] as String?,
          current: item['end_month'] == null,
          logo: '',
          description: '',
          responsibilities: List<String>.from(item['highlights'] as List),
          achievements: const [],
          technologies: const [],
          website: '',
        ),
    ];
  }

  static List<Education> education(Map<String, dynamic> portfolio) {
    return [
      for (final item in _records(portfolio, 'education'))
        Education(
          id: item['id'].toString(),
          institution: item['institution'] as String,
          degree: item['qualification'] as String,
          field: item['field_of_study'] as String,
          location: '',
          startDate: item['start_month'] as String,
          endDate: _text(item['end_month']),
          gpa: item['cgpa'] == null ? '' : _number(item['cgpa'] as num),
          logo: '',
          description: '',
          achievements: const [],
        ),
    ];
  }

  static ContactInfo contact(Map<String, dynamic> portfolio) {
    final profile = portfolio['profile'] as Map<String, dynamic>;
    final email = _text(profile['email']);
    final phone = _text(profile['phone']);
    final location = profile['location'] as String;
    final available = profile['available_for_work'] as bool;
    return ContactInfo(
      formConfig: FormConfig(
        enabled: true,
        email: email,
        subject: 'Portfolio inquiry',
        successMessage: 'Thank you. Your message has been received.',
        errorMessage: 'Your message could not be sent. Please try again.',
      ),
      contactMethods: [
        if (email.isNotEmpty)
          _contactMethod('email', 'Email', email, 'mailto:$email'),
        if (phone.isNotEmpty)
          _contactMethod('phone', 'Phone', phone, 'tel:$phone'),
        if (location.isNotEmpty)
          _contactMethod('location', 'Location', location, ''),
      ],
      socialLinks: [
        for (final link in _records(portfolio, 'social_links'))
          SocialLink(
            id: link['id'].toString(),
            platform: link['platform'] as String,
            username: '',
            url: link['url'] as String,
            icon: (link['platform'] as String).toLowerCase(),
            color: '',
          ),
      ],
      availability: Availability(
        status: available ? 'available' : 'unavailable',
        message: _availability(profile),
        openToWork: available,
        preferredContact: '',
        responseTime: '',
      ),
    );
  }

  static BlogPost blogPost(
    Map<String, dynamic> post,
    PersonalInfo author,
    Uri apiBaseUrl,
  ) {
    final tags = List<String>.from(post['tags'] as List);
    final content = post['content'] as String;
    final words = content.trim().split(RegExp(r'\s+')).length;
    final minutes = (words / 200).ceil().clamp(1, 100000);
    return BlogPost(
      id: post['id'].toString(),
      title: post['title'] as String,
      slug: post['slug'] as String,
      excerpt: post['excerpt'] as String,
      content: content,
      coverImage: resolveUrl(post['cover_image_url'] as String?, apiBaseUrl),
      author: author.name,
      authorAvatar: author.avatar,
      category: tags.isEmpty ? 'General' : tags.first,
      tags: tags,
      publishDate: (post['published_at'] ?? post['created_at']) as String,
      readTime: '$minutes min read',
      views: 0,
      likes: 0,
      featured: false,
      published: post['status'] == 'published',
    );
  }

  /// Managed media URLs start at /api/v1, while deployments may use any origin.
  static String resolveUrl(String? value, Uri apiBaseUrl) {
    if (value == null || value.isEmpty) return '';
    return apiBaseUrl.resolve(value).toString();
  }

  static List<Map<String, dynamic>> _records(
    Map<String, dynamic> source,
    String key,
  ) => (source[key] as List).cast<Map<String, dynamic>>();

  static String _text(dynamic value) => value as String? ?? '';

  static String _number(num value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toString();

  static String _availability(Map<String, dynamic> profile) =>
      profile['available_for_work'] as bool
      ? 'Available for work'
      : 'Not currently available for work';

  static ContactMethod _contactMethod(
    String type,
    String label,
    String value,
    String link,
  ) => ContactMethod(
    id: type,
    type: type,
    label: label,
    value: value,
    icon: type,
    link: link,
    primary: true,
  );
}
