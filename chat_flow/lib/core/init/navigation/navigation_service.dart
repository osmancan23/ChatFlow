import 'package:flutter/material.dart';

@immutable
final class NavigationService {
  Future<void> navigateToPage({
    required BuildContext context,
    required Widget page,
    bool removeStack = false,
  }) async {
    if (removeStack) {
      await Navigator.pushReplacement(
        context,
        // ignore: inference_failure_on_instance_creation
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1, 0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      );
    } else {
      await Navigator.push(
        context,
        // ignore: inference_failure_on_instance_creation
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1, 0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      );
    }
  }

  void navigateToBack(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> navigateToPageClear({
    required BuildContext context,
    required Widget page,
  }) async {
    await Navigator.pushAndRemoveUntil(
      context,
      // ignore: inference_failure_on_instance_creation
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0, 1);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
      (route) => false,
    );
  }
}
