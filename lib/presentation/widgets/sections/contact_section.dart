import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/url_helper.dart';
import '../../../data/models/contact.dart';
import '../common/animated_card.dart';
import '../common/scroll_reveal_widget.dart';

class ContactSection extends StatefulWidget {
  final ContactInfo contact;

  const ContactSection({super.key, required this.contact});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  IconData _getContactIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'email':
        return FontAwesomeIcons.envelope;
      case 'phone':
        return FontAwesomeIcons.phone;
      case 'location':
        return FontAwesomeIcons.locationDot;
      case 'linkedin':
        return FontAwesomeIcons.linkedin;
      case 'github':
        return FontAwesomeIcons.github;
      case 'twitter':
        return FontAwesomeIcons.twitter;
      default:
        return FontAwesomeIcons.circleInfo;
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate form submission
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.contact.formConfig.successMessage), backgroundColor: Colors.green));

      // Clear form
      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      width: double.infinity,
      padding: ResponsiveHelper.getResponsivePadding(context).copyWith(top: isMobile ? 60 : 100, bottom: isMobile ? 60 : 100),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: AppConstants.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title
              ScrollRevealWidget(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Get In Touch', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      height: 4,
                      width: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isMobile ? 16 : 24),

              // Subtitle
              ScrollRevealWidget(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  'Have a project in mind? Let\'s work together!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                ),
              ),
              SizedBox(height: isMobile ? 40 : 60),

              // Main Content
              isMobile ? _buildMobileLayout(context) : _buildDesktopLayout(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        ScrollRevealWidget(child: _buildContactInfo(context)),
        const SizedBox(height: 40),
        if (widget.contact.formConfig.enabled) ScrollRevealWidget(delay: const Duration(milliseconds: 200), child: _buildContactForm(context)),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 4, child: ScrollRevealWidget(child: _buildContactInfo(context))),
        if (widget.contact.formConfig.enabled) ...[
          const SizedBox(width: 60),
          Expanded(
            flex: 6,
            child: ScrollRevealWidget(delay: const Duration(milliseconds: 200), child: _buildContactForm(context)),
          ),
        ],
      ],
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    final primaryMethods = widget.contact.contactMethods.where((m) => m.primary).toList();
    final socialLinks = widget.contact.socialLinks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact Information', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),

        // Primary Contact Methods
        ...primaryMethods.map((method) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: AnimatedCard(
              onTap: method.link.isNotEmpty ? () => UrlHelper.launchURL(method.link) : null,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(_getContactIcon(method.icon), color: Theme.of(context).colorScheme.primary, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            method.label,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                          ),
                          const SizedBox(height: 4),
                          Text(method.value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 32),

        // Social Links
        Text('Follow Me', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: socialLinks.map((social) {
            return AnimatedCard(
              onTap: () => UrlHelper.launchURL(social.url),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12)),
                child: Icon(_getContactIcon(social.platform), color: Theme.of(context).colorScheme.primary, size: 20),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildContactForm(BuildContext context) {
    return AnimatedCard(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Send Message', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Your Name *',
                  hintText: 'John Doe',
                  prefixIcon: const Icon(FontAwesomeIcons.user, size: 18),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Your Email *',
                  hintText: 'john@example.com',
                  prefixIcon: const Icon(FontAwesomeIcons.envelope, size: 18),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Subject Field
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Subject *',
                  hintText: 'Project Inquiry',
                  prefixIcon: const Icon(FontAwesomeIcons.paperclip, size: 18),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Message Field
              TextFormField(
                controller: _messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Message *',
                  hintText: 'Tell me about your project...',
                  prefixIcon: const Padding(padding: EdgeInsets.only(bottom: 80), child: Icon(FontAwesomeIcons.message, size: 18)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message';
                  }
                  if (value.length < 10) {
                    return 'Message must be at least 10 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submitForm,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                        )
                      : const Icon(FontAwesomeIcons.paperPlane, size: 18),
                  label: Text(_isSubmitting ? 'Sending...' : 'Send Message'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
