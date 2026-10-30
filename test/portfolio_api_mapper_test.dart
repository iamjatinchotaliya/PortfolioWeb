import 'package:flutter_test/flutter_test.dart';
import 'package:portfolioweb/data/mappers/portfolio_api_mapper.dart';

void main() {
  final api = Uri.parse('http://127.0.0.1:8000/api/v1/');

  test('profile resolves managed media and uses actual public counts', () {
    final portfolio = _portfolio();
    final info = PortfolioApiMapper.personalInfo(portfolio, api);

    expect(info.name, 'Jatin');
    expect(info.title, 'Flutter developer');
    expect(info.avatar, 'http://127.0.0.1:8000/api/v1/media/photo');
    expect(info.resume, 'http://127.0.0.1:8000/api/v1/resume');
    expect(info.social.github, 'https://github.com/example');
    expect(info.social.twitter, 'https://x.com/example');
    expect(info.social.linkedin, isEmpty);
    expect(info.stats.map((stat) => stat.value), ['2.5', '1', '3']);
    expect(info.stats.map((stat) => stat.label), [
      'Years Experience',
      'Projects',
      'Skills',
    ]);
  });

  test(
    'nullable profile fields stay empty without restoring deleted media',
    () {
      final portfolio = _portfolio();
      (portfolio['profile'] as Map<String, dynamic>).addAll({
        'email': null,
        'phone': null,
        'photo_url': null,
        'resume_url': null,
        'years_experience': null,
        'available_for_work': false,
      });
      final info = PortfolioApiMapper.personalInfo(portfolio, api);
      final contact = PortfolioApiMapper.contact(portfolio);

      expect(info.email, isEmpty);
      expect(info.phone, isEmpty);
      expect(info.avatar, isEmpty);
      expect(info.resume, isEmpty);
      expect(info.stats.map((stat) => stat.label), ['Projects', 'Skills']);
      expect(contact.contactMethods.map((method) => method.type), ['location']);
      expect(contact.availability.openToWork, isFalse);
      expect(contact.availability.responseTime, isEmpty);
    },
  );

  test('skills group by server category and never fabricate proficiency', () {
    final categories = PortfolioApiMapper.skills(_portfolio());
    expect(categories.map((category) => category.name), [
      'Languages',
      'Mobile',
    ]);
    expect(categories.first.skills.map((skill) => skill.name), [
      'Dart',
      'Python',
    ]);
    expect(
      categories.expand((category) => category.skills).map((s) => s.level),
      [0, 0, 0],
    );
  });

  test('projects retain independent repository, demo and both store links', () {
    final project = PortfolioApiMapper.projects(_portfolio(), api).single;
    expect(project.id, '7');
    expect(project.description, 'A concise project summary.');
    expect(project.longDescription, 'Full project description.');
    expect(project.technologies, ['Flutter', 'Dart']);
    expect(project.github, 'https://github.com/example/app');
    expect(project.liveUrl, 'https://example.com/demo');
    expect(
      project.playStoreUrl,
      'https://play.google.com/store/apps/details?id=app',
    );
    expect(project.appStoreUrl, 'https://apps.apple.com/app/id123');
    expect(project.image, isEmpty);
    expect(project.images, isEmpty);
    expect(project.status, isEmpty);
    expect(project.duration, isEmpty);
    expect(project.featured, isTrue);
    expect(project.order, 4);
  });

  test('experience and education retain month precision and current roles', () {
    final portfolio = _portfolio();
    final experience = PortfolioApiMapper.experience(portfolio).single;
    final education = PortfolioApiMapper.education(portfolio).single;
    expect(experience.position, 'Flutter developer');
    expect(experience.startDate, '2024-02');
    expect(experience.endDate, isNull);
    expect(experience.current, isTrue);
    expect(experience.responsibilities, ['Built the mobile application.']);
    expect(experience.type, isEmpty);
    expect(education.degree, 'Bachelor of Engineering');
    expect(education.field, 'Computer Engineering');
    expect(education.startDate, '2019-06');
    expect(education.endDate, '2023-05');
    expect(education.gpa, '8.2');
  });

  test(
    'contact includes every published social platform and profile contact',
    () {
      final contact = PortfolioApiMapper.contact(_portfolio());
      expect(contact.contactMethods.map((method) => method.link), [
        'mailto:jatin@example.com',
        'tel:+91 12345 67890',
        '',
      ]);
      expect(contact.socialLinks.map((link) => link.platform), [
        'GitHub',
        'X',
        'Mastodon',
      ]);
      expect(contact.socialLinks.last.url, 'https://example.social/@jatin');
      expect(contact.formConfig.enabled, isTrue);
      expect(contact.formConfig.successMessage, contains('received'));
      expect(contact.availability.openToWork, isTrue);
    },
  );

  test(
    'published blogs preserve content, tags, author and publication time',
    () {
      final post = PortfolioApiMapper.blogPost(
        {
          'id': 12,
          'title': 'Calling a portfolio API',
          'slug': 'calling-a-portfolio-api',
          'excerpt': 'Connecting the frontend.',
          'content': List.filled(201, 'word').join(' '),
          'cover_image_url': 'https://cdn.example.com/blog.png',
          'tags': ['Flutter', 'API'],
          'status': 'published',
          'published_at': '2026-10-28T08:00:00Z',
          'created_at': '2026-10-27T08:00:00Z',
        },
        PortfolioApiMapper.personalInfo(_portfolio(), api),
        api,
      );

      expect(post.author, 'Jatin');
      expect(post.authorAvatar, 'http://127.0.0.1:8000/api/v1/media/photo');
      expect(post.coverImage, 'https://cdn.example.com/blog.png');
      expect(post.category, 'Flutter');
      expect(post.tags, ['Flutter', 'API']);
      expect(post.publishDate, '2026-10-28T08:00:00Z');
      expect(post.readTime, '2 min read');
      expect(post.published, isTrue);
      expect(post.featured, isFalse);
      expect(post.views, 0);
      expect(post.likes, 0);
    },
  );

  test('blog optional media and publication time have safe fallbacks', () {
    final post = PortfolioApiMapper.blogPost(
      {
        'id': 13,
        'title': 'Draft',
        'slug': 'draft',
        'excerpt': 'Draft excerpt.',
        'content': 'Draft content.',
        'cover_image_url': null,
        'tags': <String>[],
        'status': 'draft',
        'published_at': null,
        'created_at': '2026-10-27T08:00:00Z',
      },
      PortfolioApiMapper.personalInfo(_portfolio(), api),
      api,
    );

    expect(post.coverImage, isEmpty);
    expect(post.category, 'General');
    expect(post.publishDate, '2026-10-27T08:00:00Z');
    expect(post.published, isFalse);
  });
}

Map<String, dynamic> _portfolio() => {
  'profile': <String, dynamic>{
    'id': 1,
    'name': 'Jatin',
    'headline': 'Flutter developer',
    'bio': 'I build mobile applications.',
    'location': 'India',
    'available_for_work': true,
    'email': 'jatin@example.com',
    'phone': '+91 12345 67890',
    'years_experience': 2.5,
    'photo_url': '/api/v1/media/photo',
    'resume_url': '/api/v1/resume',
  },
  'skills': <Map<String, dynamic>>[
    {'id': 1, 'name': 'Dart', 'category': 'Languages', 'display_order': 0},
    {'id': 2, 'name': 'Flutter', 'category': 'Mobile', 'display_order': 1},
    {'id': 3, 'name': 'Python', 'category': 'Languages', 'display_order': 2},
  ],
  'projects': <Map<String, dynamic>>[
    {
      'id': 7,
      'title': 'Portfolio app',
      'slug': 'portfolio-app',
      'summary': 'A concise project summary.',
      'description': 'Full project description.',
      'featured': true,
      'display_order': 4,
      'repository_url': 'https://github.com/example/app',
      'demo_url': 'https://example.com/demo',
      'play_store_url': 'https://play.google.com/store/apps/details?id=app',
      'app_store_url': 'https://apps.apple.com/app/id123',
      'image_url': null,
      'skills': <Map<String, dynamic>>[
        {'id': 2, 'name': 'Flutter', 'category': 'Mobile', 'display_order': 1},
        {'id': 1, 'name': 'Dart', 'category': 'Languages', 'display_order': 0},
      ],
    },
  ],
  'experiences': <Map<String, dynamic>>[
    {
      'id': 4,
      'company': 'Example Company',
      'role': 'Flutter developer',
      'location': 'India',
      'start_month': '2024-02',
      'end_month': null,
      'highlights': ['Built the mobile application.'],
      'display_order': 0,
    },
  ],
  'education': <Map<String, dynamic>>[
    {
      'id': 5,
      'institution': 'Example University',
      'qualification': 'Bachelor of Engineering',
      'field_of_study': 'Computer Engineering',
      'start_month': '2019-06',
      'end_month': '2023-05',
      'cgpa': 8.2,
      'display_order': 0,
    },
  ],
  'social_links': <Map<String, dynamic>>[
    {
      'id': 1,
      'platform': 'GitHub',
      'url': 'https://github.com/example',
      'display_order': 0,
    },
    {
      'id': 2,
      'platform': 'X',
      'url': 'https://x.com/example',
      'display_order': 1,
    },
    {
      'id': 3,
      'platform': 'Mastodon',
      'url': 'https://example.social/@jatin',
      'display_order': 2,
    },
  ],
};
