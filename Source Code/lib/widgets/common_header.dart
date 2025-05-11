import 'package:flutter/material.dart';

/// A reusable app bar widget that displays the application header.
class CommonHeader extends StatelessWidget implements PreferredSizeWidget {
  const CommonHeader({super.key});

  /// Builds the header widget with a title and styling.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        height: preferredSize.height,
        alignment: Alignment.center,
        child: const Text(
          'Cross Platform Application Development - Assignment 1',
          style: TextStyle(
            fontSize: 22, // Slightly smaller for long text
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
            letterSpacing: 1.1,
            shadows: [
              Shadow(
                color: Colors.black12,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  /// The preferred size of the header.
  @override
  Size get preferredSize => const Size.fromHeight(70);
} 