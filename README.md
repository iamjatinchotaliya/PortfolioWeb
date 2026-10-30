# 🎨 Modern Flutter Web Portfolio

**Python API integration:** Follow [API_SETUP.md](API_SETUP.md) to run this app with the sibling `my_portfolio` backend. The live API replaces bundled portfolio JSON and the demo contact submission. Older architecture examples below are retained for reference.

A fully responsive, highly animated, production-ready Flutter web portfolio built with world-class architecture, Riverpod for state management, and GoRouter for navigation. Features stunning animations, light/dark themes, 3D elements, and comprehensive data-driven content.

## ✨ Features

### 🎯 Core Features

- **🌓 Light/Dark Theme**: Smooth theme switching with persistent preferences
- **📱 Fully Responsive**: Optimized for mobile, tablet, desktop, and large screens
- **🎭 Rich Animations**: Scroll reveals, hover effects, micro-interactions, and page transitions
- **🎨 Modern UI**: Clean, professional design with gradient accents and glassmorphism
- **🔄 Riverpod**: Clean architecture with proper state management
- **🧭 GoRouter Navigation**: Deep linking support and smooth route transitions
- **📊 Data-Driven**: Public content loaded from the my_portfolio Python API

### 🎬 Animation Features

- Scroll-based reveal animations
- Smooth page transitions
- Hover effects on cards and buttons
- Staggered list animations
- Rotating text effects
- Gradient animations
- Scale and elevation transitions

### 📑 Sections

1. **Hero Section**: Eye-catching introduction with animated text and CTA buttons
2. **About Section**: Personal bio, statistics, and downloadable resume
3. **Skills Section**: Categorized skills with animated progress indicators
4. **Projects Section**: Portfolio projects with 3D model integration
5. **Experience Section**: Professional timeline with company details
6. **Blog Section**: Featured articles and blog posts
7. **Contact Section**: Contact form with social links

### 🔧 Technical Features

- **SEO Optimized**: Comprehensive meta tags and Open Graph support
- **Lazy Loading**: Optimized asset loading for better performance
- **Accessibility**: ARIA labels and keyboard navigation support
- **Type Safety**: Strongly typed models with Equatable
- **Repository Pattern**: Clean data layer architecture
- **Shared Repository**: In-flight request deduplication and cached API content
- **Google Fonts**: Beautiful typography with Inter and Poppins

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart         # App-wide constants
│   ├── themes/
│   │   └── app_theme.dart             # Light/Dark theme definitions
│   └── utils/
│       ├── app_router.dart            # GoRouter configuration
│       ├── responsive_helper.dart      # Responsive utilities
│       └── url_helper.dart            # URL launcher utilities
├── data/
│   ├── models/
│   │   ├── personal_info.dart         # Personal info model
│   │   ├── skill.dart                 # Skills model
│   │   ├── project.dart               # Projects model
│   │   ├── experience.dart            # Experience model
│   │   ├── blog_post.dart             # Blog post model
│   │   └── contact.dart               # Contact info model
│   └── repositories/
│       └── data_repository.dart       # Data access layer
├── presentation/
│   ├── blocs/
│   │   └── theme/
│   │       ├── theme_bloc.dart        # Theme state management
│   │       ├── theme_event.dart       # Theme events
│   │       └── theme_state.dart       # Theme states
│   ├── pages/
│   │   ├── home_page.dart             # Main home page
│   │   ├── project_detail_page.dart   # Project details
│   │   └── blog_detail_page.dart      # Blog post details
│   └── widgets/
│       ├── common/
│       │   ├── animated_button.dart    # Animated button widget
│       │   ├── animated_card.dart      # Animated card widget
│       │   └── scroll_reveal_widget.dart # Scroll animation widget
│       ├── navigation/
│       │   └── custom_navbar.dart      # Responsive navigation bar
│       └── sections/
│           └── hero_section.dart       # Hero section widget
└── main.dart                          # App entry point

assets/
├── data/
│   ├── personal_info.json             # Your personal information
│   ├── skills.json                    # Your skills data
│   ├── projects.json                  # Your projects data
│   ├── experience.json                # Your work experience
│   ├── blog.json                      # Your blog posts
│   └── contact.json                   # Contact information
├── animations/                        # Lottie/Rive animations
├── 3d/                               # 3D models (.glb files)
└── images/                           # Images and icons
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.10.1 or higher)
- Dart SDK
- A code editor (VS Code, Android Studio, etc.)

### Installation

1. **Clone the repository**

```bash
git clone <your-repo-url>
cd portfolioweb
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Run the app**

```bash
# For web
flutter run -d chrome

# For mobile
flutter run
```

4. **Build for production**

```bash
# Web build
flutter build web --release

# Mobile builds
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

## 🎨 Customization Guide

Update portfolio content through the Python backend's authenticated admin API. The files in assets/data are legacy examples and are no longer loaded by the application.

### 7. Customize Theme Colors

Edit `lib/core/themes/app_theme.dart` to change colors:

```dart
static const Color lightPrimary = Color(0xFF6366F1); // Your color
static const Color darkPrimary = Color(0xFF818CF8);  // Your color
```

### 8. Add Images

Place your images in the appropriate folders:

- `assets/images/` - General images
- `assets/images/projects/` - Project screenshots
- `assets/images/companies/` - Company logos
- `assets/images/blog/` - Blog post covers

### 9. Add Animations

- **Lottie**: Place `.json` files in `assets/animations/`
- **Rive**: Place `.riv` files in `assets/animations/`
- **3D Models**: Place `.glb` files in `assets/3d/`

### 10. Update SEO Metadata

Edit `web/index.html`:

```html
<title>Your Name - Your Title</title>
<meta name="description" content="Your description" />
<meta property="og:image" content="your-og-image-url" />
```

## 📦 Dependencies

### Core Dependencies

- **flutter_bloc** (^8.1.6) - State management
- **go_router** (^14.6.2) - Navigation
- **google_fonts** (^6.2.1) - Typography
- **equatable** (^2.0.5) - Value equality

### UI & Animation

- **lottie** (^3.1.3) - Lottie animations
- **rive** (^0.13.19) - Rive animations
- **animations** (^2.0.11) - Flutter animations
- **visibility_detector** (^0.4.0+2) - Scroll detection
- **flutter_staggered_animations** (^1.1.1) - Staggered animations
- **model_viewer_plus** (^1.8.0) - 3D model viewing

### Utilities

- **responsive_framework** (^1.5.0) - Responsive design
- **url_launcher** (^6.3.1) - URL launching
- **font_awesome_flutter** (^10.7.0) - Icon pack
- **flutter_svg** (^2.0.10+1) - SVG support
- **shimmer** (^3.0.0) - Shimmer effects

## 🏗️ Architecture

### BLoC Pattern

The app follows the BLoC (Business Logic Component) pattern for clean separation of concerns:

```
Presentation Layer (UI)
    ↓
BLoC Layer (Business Logic)
    ↓
Repository Layer (Data Access)
    ↓
Data Sources (JSON Assets)
```

### Key Principles

- **Single Responsibility**: Each class has one clear purpose
- **Dependency Injection**: Dependencies passed through constructors
- **Immutability**: Using Equatable for immutable states
- **Type Safety**: Strong typing throughout
- **Reusability**: Modular, reusable widgets

## 🎯 Best Practices

1. **Performance**

   - Lazy loading of assets
   - Widget const constructors
   - Efficient state management
   - Image optimization

2. **Accessibility**

   - Semantic HTML
   - ARIA labels
   - Keyboard navigation
   - Screen reader support

3. **Responsiveness**

   - Mobile-first approach
   - Breakpoint-based layouts
   - Flexible widgets
   - Touch-friendly targets

4. **Code Quality**
   - Clean code principles
   - Comprehensive comments
   - Type safety
   - Error handling

## 🌐 Deployment

### Web Deployment

**Firebase Hosting**

```bash
flutter build web --release
firebase init hosting
firebase deploy
```

**Netlify**

```bash
flutter build web --release
# Drag and drop the 'build/web' folder to Netlify
```

**GitHub Pages**

```bash
flutter build web --release --base-href "/your-repo/"
# Push build/web contents to gh-pages branch
```

### Mobile Deployment

**Google Play Store**

```bash
flutter build appbundle --release
```

**Apple App Store**

```bash
flutter build ios --release
```

## 🐛 Troubleshooting

### Common Issues

**Issue**: Assets not loading

```bash
# Solution: Run flutter clean and rebuild
flutter clean
flutter pub get
flutter run
```

**Issue**: Theme not switching

```bash
# Solution: Check BLoC is properly provided
# Ensure BlocProvider wraps MaterialApp
```

**Issue**: Navigation not working

```bash
# Solution: Verify GoRouter configuration
# Check route paths and names
```

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 👨‍💻 Author

**Alex Johnson**

- Website: [your-domain.com](https://your-domain.com)
- GitHub: [@alexjohnson](https://github.com/alexjohnson)
- LinkedIn: [Alex Johnson](https://linkedin.com/in/alexjohnson)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- All open-source contributors
- Design inspiration from modern web portfolios

## 📞 Support

For questions or issues, please:

1. Check the [documentation](#)
2. Search existing [issues](https://github.com/yourusername/portfolio/issues)
3. Create a new issue if needed

---

**⭐ Star this repo if you find it helpful!**

Made with ❤️ using Flutter
