class AppConstants {
  // App Info
  static const String appName = 'Portfolio';
  static const String appVersion = '1.0.0';

  // Routes
  static const String homeRoute = '/';
  static const String aboutRoute = '/about';
  static const String skillsRoute = '/skills';
  static const String projectsRoute = '/projects';
  static const String projectDetailRoute = '/projects/:id';
  static const String experienceRoute = '/experience';
  static const String blogRoute = '/blog';
  static const String blogDetailRoute = '/blog/:slug';
  static const String routeBlogDetail = '/blog'; // For navigation without parameter
  static const String contactRoute = '/contact';

  // UI Constants
  static const double borderRadius = 12.0;

  // Section IDs for scrolling
  static const String homeSectionId = 'home';
  static const String aboutSectionId = 'about';
  static const String skillsSectionId = 'skills';
  static const String projectsSectionId = 'projects';
  static const String experienceSectionId = 'experience';
  static const String blogSectionId = 'blog';
  static const String contactSectionId = 'contact';

  // Breakpoints (matching responsive_framework defaults)
  static const double mobileBreakpoint = 450;
  static const double tabletBreakpoint = 800;
  static const double desktopBreakpoint = 1000;
  static const double largeDesktopBreakpoint = 1920;

  // Max Content Width
  static const double maxContentWidth = 1200;
  static const double maxWideContentWidth = 1400;

  // Animation Durations (in milliseconds)
  static const int animationDurationFast = 200;
  static const int animationDurationNormal = 300;
  static const int animationDurationSlow = 500;
  static const int animationDurationSlower = 800;

  // Scroll Animation
  static const double scrollAnimationThreshold = 0.1;

  // Hero Tags
  static const String heroNavbar = 'navbar';
  static const String heroProfileImage = 'profile_image';

  // Local Storage Keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';

  // External Links
  static const String githubRepoUrl = 'https://github.com/yourusername/portfolio';

  // SEO
  static const String siteTitle = 'Alex Johnson - Full Stack Developer';
  static const String siteDescription =
      'Portfolio of Alex Johnson - Full Stack Developer & UI/UX Designer specializing in Flutter, React, and modern web technologies';
  static const String siteKeywords = 'flutter, developer, portfolio, web development, mobile development, react, UI/UX';
  static const String siteAuthor = 'Alex Johnson';
  static const String siteUrl = 'https://your-domain.com';

  // Social Media (OpenGraph & Twitter)
  static const String ogImage = '/assets/images/og-image.png';
  static const String twitterHandle = '@alexjohnson';

  // Form Validation
  static const int nameMinLength = 2;
  static const int nameMaxLength = 50;
  static const int messageMinLength = 10;
  static const int messageMaxLength = 500;

  // Pagination
  static const int blogPostsPerPage = 6;
  static const int projectsPerPage = 6;

  // Lottie/Rive Animations
  static const String heroAnimationPath = 'assets/animations/hero-animation.json';
  static const String loadingAnimationPath = 'assets/animations/loading.json';
  static const String successAnimationPath = 'assets/animations/success.json';
  static const String errorAnimationPath = 'assets/animations/error.json';

  // 3D Models
  static const String defaultModelPath = 'assets/3d/default-model.glb';
}
