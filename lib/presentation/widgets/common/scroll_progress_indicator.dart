import 'package:flutter/material.dart';

class ScrollProgressIndicator extends StatelessWidget {
  final ScrollController scrollController;

  const ScrollProgressIndicator({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, child) {
        // Check if scrollController has a position before accessing it
        if (!scrollController.hasClients || !scrollController.position.hasContentDimensions) {
          return const SizedBox.shrink();
        }

        final maxScroll = scrollController.position.maxScrollExtent;
        final currentScroll = scrollController.position.pixels;
        final progress = maxScroll > 0 ? (currentScroll / maxScroll).clamp(0.0, 1.0) : 0.0;

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Positioned(
          right: 20,
          top: 100,
          bottom: 100,
          child: Container(
            width: 4,
            decoration: BoxDecoration(
              color: (isDark ? const Color(0xFF1A1F3A) : const Color(0xFFE8EEFF)).withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.topCenter,
              heightFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDark
                        ? [const Color(0xFF00F5FF), const Color(0xFFFF0080), const Color(0xFFFFD60A)]
                        : [const Color(0xFF00D9FF), const Color(0xFFFF006E), const Color(0xFFFFBE0B)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(color: (isDark ? const Color(0xFF00F5FF) : const Color(0xFF00D9FF)).withOpacity(0.5), blurRadius: 8, spreadRadius: 1),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
