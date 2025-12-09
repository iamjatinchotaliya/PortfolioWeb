import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/personal_info.dart';
import '../models/skill.dart';
import '../models/project.dart';
import '../models/experience.dart';
import '../models/blog_post.dart';
import '../models/contact.dart';

class DataRepository {
  // Singleton pattern
  static final DataRepository _instance = DataRepository._internal();
  factory DataRepository() => _instance;
  DataRepository._internal();

  // Cache
  PersonalInfo? _personalInfo;
  List<SkillCategory>? _skills;
  List<Project>? _projects;
  List<Experience>? _experience;
  List<Education>? _education;
  List<Certification>? _certifications;
  List<BlogPost>? _blogPosts;
  List<String>? _blogCategories;
  ContactInfo? _contactInfo;

  // Load Personal Info
  Future<PersonalInfo> getPersonalInfo() async {
    if (_personalInfo != null) return _personalInfo!;

    final String response =
        await rootBundle.loadString('assets/data/personal_info.json');
    final data = json.decode(response);
    _personalInfo = PersonalInfo.fromJson(data);
    return _personalInfo!;
  }

  // Load Skills
  Future<List<SkillCategory>> getSkills() async {
    if (_skills != null) return _skills!;

    final String response = await rootBundle.loadString('assets/data/skills.json');
    final data = json.decode(response);
    _skills = (data['categories'] as List)
        .map((category) => SkillCategory.fromJson(category))
        .toList();
    return _skills!;
  }

  // Load Projects
  Future<List<Project>> getProjects() async {
    if (_projects != null) return _projects!;

    final String response = await rootBundle.loadString('assets/data/projects.json');
    final data = json.decode(response);
    _projects = (data['projects'] as List)
        .map((project) => Project.fromJson(project))
        .toList();
    // Sort by order
    _projects!.sort((a, b) => a.order.compareTo(b.order));
    return _projects!;
  }

  // Get Featured Projects
  Future<List<Project>> getFeaturedProjects() async {
    final projects = await getProjects();
    return projects.where((project) => project.featured).toList();
  }

  // Get Projects by Category
  Future<List<Project>> getProjectsByCategory(String category) async {
    final projects = await getProjects();
    return projects.where((project) => project.category == category).toList();
  }

  // Get Project by ID
  Future<Project?> getProjectById(String id) async {
    final projects = await getProjects();
    try {
      return projects.firstWhere((project) => project.id == id);
    } catch (e) {
      return null;
    }
  }

  // Load Experience
  Future<List<Experience>> getExperience() async {
    if (_experience != null) return _experience!;

    final String response =
        await rootBundle.loadString('assets/data/experience.json');
    final data = json.decode(response);
    _experience = (data['experience'] as List)
        .map((exp) => Experience.fromJson(exp))
        .toList();
    return _experience!;
  }

  // Load Education
  Future<List<Education>> getEducation() async {
    if (_education != null) return _education!;

    final String response =
        await rootBundle.loadString('assets/data/experience.json');
    final data = json.decode(response);
    _education = (data['education'] as List)
        .map((edu) => Education.fromJson(edu))
        .toList();
    return _education!;
  }

  // Load Certifications
  Future<List<Certification>> getCertifications() async {
    if (_certifications != null) return _certifications!;

    final String response =
        await rootBundle.loadString('assets/data/experience.json');
    final data = json.decode(response);
    _certifications = (data['certifications'] as List)
        .map((cert) => Certification.fromJson(cert))
        .toList();
    return _certifications!;
  }

  // Load Blog Posts
  Future<List<BlogPost>> getBlogPosts() async {
    if (_blogPosts != null) return _blogPosts!;

    final String response = await rootBundle.loadString('assets/data/blog.json');
    final data = json.decode(response);
    _blogPosts = (data['posts'] as List)
        .map((post) => BlogPost.fromJson(post))
        .toList();
    return _blogPosts!;
  }

  // Get Featured Blog Posts
  Future<List<BlogPost>> getFeaturedBlogPosts() async {
    final posts = await getBlogPosts();
    return posts.where((post) => post.featured && post.published).toList();
  }

  // Get Blog Posts by Category
  Future<List<BlogPost>> getBlogPostsByCategory(String category) async {
    final posts = await getBlogPosts();
    return posts
        .where((post) => post.category == category && post.published)
        .toList();
  }

  // Get Blog Post by Slug
  Future<BlogPost?> getBlogPostBySlug(String slug) async {
    final posts = await getBlogPosts();
    try {
      return posts.firstWhere((post) => post.slug == slug);
    } catch (e) {
      return null;
    }
  }

  // Load Blog Categories
  Future<List<String>> getBlogCategories() async {
    if (_blogCategories != null) return _blogCategories!;

    final String response = await rootBundle.loadString('assets/data/blog.json');
    final data = json.decode(response);
    _blogCategories = List<String>.from(data['categories'] as List);
    return _blogCategories!;
  }

  // Load Contact Info
  Future<ContactInfo> getContactInfo() async {
    if (_contactInfo != null) return _contactInfo!;

    final String response = await rootBundle.loadString('assets/data/contact.json');
    final data = json.decode(response);
    _contactInfo = ContactInfo.fromJson(data);
    return _contactInfo!;
  }

  // Clear cache (useful for hot reload or data refresh)
  void clearCache() {
    _personalInfo = null;
    _skills = null;
    _projects = null;
    _experience = null;
    _education = null;
    _certifications = null;
    _blogPosts = null;
    _blogCategories = null;
    _contactInfo = null;
  }
}
