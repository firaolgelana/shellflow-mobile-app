import 'package:flutter/material.dart';

class FeaturesPage extends StatelessWidget {
  const FeaturesPage({super.key});

  static const List<_FeatureItem> _features = [
    _FeatureItem(
      title: 'Smart Task Scheduling',
      description: 'Create, organize, and prioritize tasks effortlessly. Set due dates and get automatic overdue alerts so you never miss a deadline.',
      icon: Icons.calendar_month_rounded,
      color: Colors.blue,
    ),
    _FeatureItem(
      title: 'Social Accountability',
      description: 'Share your productivity journey. Post tasks to the feed, get likes from friends, and stay motivated by seeing others succeed.',
      icon: Icons.people_alt_rounded,
      color: Colors.purple,
    ),
    _FeatureItem(
      title: 'Real-time Analytics',
      description: 'Visualize your progress with dynamic charts. Track daily completion rates and view your weekly productivity streak.',
      icon: Icons.pie_chart_rounded,
      color: Colors.orange,
    ),
    _FeatureItem(
      title: 'Interactive Feed',
      description: 'Engage with your network. Like and comment on your friends\' achievements directly from your social feed.',
      icon: Icons.thumb_up_alt_rounded,
      color: Colors.pink,
    ),
    _FeatureItem(
      title: 'Privacy Controls',
      description: 'You are in control. Set your profile to private, choose who sees your tasks, and manage data visibility settings.',
      icon: Icons.security_rounded,
      color: Colors.green,
    ),
    _FeatureItem(
      title: 'Dark Mode & Customization',
      description: 'A beautiful interface that adapts to your style. Switch between Light and Dark themes to reduce eye strain.',
      icon: Icons.dark_mode_rounded,
      color: Colors.indigo,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Platform Features'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // --- HERO SECTION ---
          _buildHeroSection(context),
          
          const SizedBox(height: 20),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "What you can do",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(height: 10),

          // --- FEATURE LIST LOOP ---
          ..._features.map((feature) => _FeatureCard(item: feature)),

          const SizedBox(height: 30),
          
          // --- FOOTER CTA ---
          _buildFooter(context),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.rocket_launch_rounded, size: 48, color: Colors.white),
          const SizedBox(height: 16),
          const Text(
            "Productivity Meets Community",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Shell Flow combines powerful task management with social interaction to help you grow.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blue.shade50,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.check_circle, color: Colors.green[300], size: 40),
          const SizedBox(height: 8),
          const Text(
            "Ready to be productive?",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// --- HELPER CLASSES ---

// 1. Data Model for a Feature
class _FeatureItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _FeatureItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

// 2. The Widget that displays a single feature
class _FeatureCard extends StatelessWidget {
  final _FeatureItem item;

  const _FeatureCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Container
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: item.color, size: 24),
            ),
            const SizedBox(width: 16),
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}