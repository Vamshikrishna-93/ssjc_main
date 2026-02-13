import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtext;
  final IconData icon;
  final Color iconColor;
  final Widget? content;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtext,
    required this.icon,
    required this.iconColor,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.bodySmall?.copyWith(fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(width: 8),
              if (content != null)
                content!
              else
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtext,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
