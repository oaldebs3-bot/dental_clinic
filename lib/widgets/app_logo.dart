import 'package:flutter/material.dart';
import 'dental_colors.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const AppLogo({super.key, this.size = 72, this.showText = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size, height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [DentalColors.primary, Color(0xFF0F766E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(size * 0.28),
            boxShadow: [BoxShadow(color: DentalColors.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: const Icon(Icons.medical_services_rounded, size: 40, color: Colors.white),
        ),
        if (showText) ...[
          const SizedBox(height: 12),
          const Text('عيادة الأسنان', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2)),
          const SizedBox(height: 4),
          Text('Dental Clinic', style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.4), letterSpacing: 2)),
        ],
      ],
    );
  }
}
