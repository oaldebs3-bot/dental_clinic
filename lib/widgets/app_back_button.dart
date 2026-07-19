import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AppBackButton({super.key, this.onPressed});

  String _parentRoute(String location) {
    final uri = Uri.tryParse(location);
    final segments = uri?.pathSegments ?? [];
    if (segments.isEmpty) return '/dashboard';

    switch (segments[0]) {
      case 'add-patient':
      case 'edit-patient':
        return '/patients';
      case 'patient':
        return '/patients';
      case 'dental-chart':
        if (segments.length > 1) return '/patient/${segments[1]}';
        return '/patients';
      case 'book-appointment':
        return '/appointments';
      default:
        return '/dashboard';
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_rounded),
      onPressed: onPressed ?? () {
        final location = GoRouterState.of(context).uri.toString();
        context.go(_parentRoute(location));
      },
      tooltip: 'رجوع',
    );
  }
}
