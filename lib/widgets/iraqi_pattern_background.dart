import 'package:flutter/material.dart';
import '../theme/iraqi_theme.dart';

/// A decorative background widget with Iraqi heritage-inspired patterns.
/// Uses geometric patterns inspired by Mesopotamian art.
class IraqiPatternBackground extends StatelessWidget {
  final Widget child;
  final bool showPattern;

  const IraqiPatternBackground({
    super.key,
    required this.child,
    this.showPattern = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background gradient
        Container(
          decoration: const BoxDecoration(
            gradient: IraqiTheme.mesopotamianGradient,
          ),
        ),
        // Decorative top arc
        if (showPattern)
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: IraqiTheme.primaryGold.withAlpha(31),
              ),
            ),
          ),
        // Decorative bottom arc
        if (showPattern)
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: IraqiTheme.tigrisTeal.withAlpha(51),
              ),
            ),
          ),
        // Decorative middle element
        if (showPattern)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            right: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: IraqiTheme.primaryGold.withAlpha(20),
              ),
            ),
          ),
        // Main content
        child,
      ],
    );
  }
}
