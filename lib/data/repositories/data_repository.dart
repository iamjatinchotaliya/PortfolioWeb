import '../mappers/portfolio_api_mapper.dart';
import '../models/personal_info.dart';
import '../models/skill.dart';
import '../models/project.dart';
import '../models/experience.dart';
import '../models/blog_post.dart';
import '../models/contact.dart';
import '../services/portfolio_api_client.dart';

class DataRepository {
  DataRepository({PortfolioApiClient? apiClient})
    : _api = apiClient ?? PortfolioApiClient();

  final PortfolioApiClient _api;
  Future<Map<String, dynamic>>? _portfolio;
  Future<List<BlogPost>>? _blogs;

  // Share one in-flight request across all sections and evict failures for retry.
  Future<Map<String, dynamic>> _getPortfolio() async {
    final pending = _portfolio ??= _loadPortfolio();
    try {
      return await pending;
    } catch (_) {
      if (identical(_portfolio, pending)) _portfolio = null;
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _loadPortfolio() async {
    final data = await _api.get('portfolio');
    if (data['profile'] is! Map<String, dynamic> ||
        [
          'skills',
          'projects',
          'experiences',
          'education',
          'social_links',
        ].any((key) => data[key] is! List)) {
      throw const PortfolioApiException(
        'The server returned incomplete portfolio data.',
      );
    }
    return data;
  }

  Future<PersonalInfo> getPersonalInfo() async =>
      PortfolioApiMapper.personalInfo(await _getPortfolio(), _api.baseUrl);

  Future<List<SkillCategory>> getSkills() async =>
      PortfolioApiMapper.skills(await _getPortfolio());

  Future<List<Project>> getProjects() async =>
      PortfolioApiMapper.projects(await _getPortfolio(), _api.baseUrl);

  Future<List<Project>> getFeaturedProjects() async =>
      (await getProjects()).where((project) => project.featured).toList();

  Future<List<Project>> getProjectsByCategory(String category) async =>
      (await getProjects())
          .where((project) => project.category == category)
          .toList();

  Future<Project?> getProjectById(String id) async {
    final projects = await getProjects();
    for (final project in projects) {
      if (project.id == id) return project;
    }
    return null;
  }

  Future<List<Experience>> getExperience() async =>
      PortfolioApiMapper.experience(await _getPortfolio());

  Future<List<Education>> getEducation() async =>
      PortfolioApiMapper.education(await _getPortfolio());

  // The public backend has no certifications collection.
  Future<List<Certification>> getCertifications() async => const [];

  Future<List<BlogPost>> getBlogPosts() async {
    final pending = _blogs ??= _loadBlogs();
    try {
      return await pending;
    } catch (_) {
      if (identical(_blogs, pending)) _blogs = null;
      rethrow;
    }
  }

  Future<List<BlogPost>> _loadBlogs() async {
    final author = await getPersonalInfo();
    final posts = <BlogPost>[];
    var offset = 0;
    while (true) {
      final page = await _api.get(
        'blogs',
        query: {'limit': '100', 'offset': '$offset'},
      );
      final items = page['items'];
      final total = page['total'];
      if (items is! List || total is! int) {
        throw const PortfolioApiException(
          'The server returned invalid blog data.',
        );
      }
      posts.addAll(
        items.map(
          (item) => PortfolioApiMapper.blogPost(
            item as Map<String, dynamic>,
            author,
            _api.baseUrl,
          ),
        ),
      );
      offset += items.length;
      if (items.isEmpty || offset >= total) break;
    }
    return posts;
  }

  Future<List<BlogPost>> getFeaturedBlogPosts() async => (await getBlogPosts())
      .where((post) => post.featured && post.published)
      .toList();

  Future<List<BlogPost>> getBlogPostsByCategory(String category) async =>
      (await getBlogPosts())
          .where((post) => post.category == category && post.published)
          .toList();

  Future<BlogPost?> getBlogPostBySlug(String slug) async {
    try {
      final post = await _api.get('blogs/slug/${Uri.encodeComponent(slug)}');
      return PortfolioApiMapper.blogPost(
        post,
        await getPersonalInfo(),
        _api.baseUrl,
      );
    } on PortfolioApiException catch (error) {
      if (error.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<List<String>> getBlogCategories() async =>
      (await getBlogPosts()).map((post) => post.category).toSet().toList();

  Future<ContactInfo> getContactInfo() async =>
      PortfolioApiMapper.contact(await _getPortfolio());

  Future<void> submitContact({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    await _api.post('contact', {
      'name': name.trim(),
      'email': email.trim(),
      'subject': subject.trim(),
      'message': message.trim(),
    });
  }

  void clearCache() {
    _portfolio = null;
    _blogs = null;
  }

  void dispose() => _api.close();
}
