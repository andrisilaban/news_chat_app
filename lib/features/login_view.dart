import 'package:flutter/material.dart';
import 'package:news_chat_app/service/auth_service.dart';

class LoginView extends StatelessWidget {
  final AuthService authService;
  LoginView({super.key, AuthService? authService})
    : authService = authService ?? AuthService();

  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF59E0B,
      ), // Matches the warm yellow/orange in the asset
      body: Column(
        children: [
          // ── TOP: Image ─────────────────────────────
          Expanded(
            flex: 5,
            child: SizedBox(
              width: double.infinity,
              child: Image.asset('assets/login.jpg', fit: BoxFit.cover),
            ),
          ),

          // ── BOTTOM: white rounded card ───────────────────────────────
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to your account',
                    style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 36),

                  // Google Sign-In Button
                  _GoogleSignInButton(
                    key: const Key('google_sign_in_button'),
                    onTap: () async {
                      try {
                        await authService.signInWithGoogle();
                      } catch (e) {
                        showError(context, e.toString());
                      }
                    },
                  ),

                  const Spacer(),

                  // Continue as guest
                  GestureDetector(
                    onTap: () async {
                      try {
                        await authService.signInAsGuest();
                      } catch (e) {
                        showError(context, e.toString());
                      }
                    },
                    child: const Text(
                      'Continue as guest',
                      key: Key('guest_sign_in_button'),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF7B52E0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Google Sign-In Button ─────────────────────────────────────────────────────
class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google "G" logo drawn with CustomPaint
            const _GoogleLogo(size: 24),
            const SizedBox(width: 12),
            const Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Google "G" logo ───────────────────────────────────────────────────────────
class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleGPainter()),
    );
  }
}

class _GoogleGPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;
    final double r = w / 2;

    final paintFill = Paint()..style = PaintingStyle.fill;

    // Clip to circle
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r)),
    );

    // Background white circle
    canvas.drawCircle(Offset(cx, cy), r, paintFill..color = Colors.white);

    // Blue sector (top-left)
    _drawSector(
      canvas,
      cx,
      cy,
      r,
      -120 * (3.14159 / 180),
      -2 * (3.14159 / 180),
      const Color(0xFF4285F4),
      paintFill,
    );
    // Red sector (top arc going right)
    _drawSector(
      canvas,
      cx,
      cy,
      r,
      -2 * (3.14159 / 180),
      90 * (3.14159 / 180),
      const Color(0xFFEA4335),
      paintFill,
    );
    // Yellow sector
    _drawSector(
      canvas,
      cx,
      cy,
      r,
      90 * (3.14159 / 180),
      180 * (3.14159 / 180),
      const Color(0xFFFBBC05),
      paintFill,
    );
    // Green sector
    _drawSector(
      canvas,
      cx,
      cy,
      r,
      180 * (3.14159 / 180),
      240 * (3.14159 / 180),
      const Color(0xFF34A853),
      paintFill,
    );

    // Center white circle (donut)
    canvas.drawCircle(
      Offset(cx, cy),
      r * 0.58,
      paintFill..color = Colors.white,
    );

    // Right horizontal bar (blue)
    final barRect = Rect.fromLTRB(cx, cy - r * 0.19, cx + r, cy + r * 0.19);
    canvas.drawRect(barRect, paintFill..color = const Color(0xFF4285F4));

    // Center white circle again to restore donut shape
    canvas.drawCircle(
      Offset(cx, cy),
      r * 0.58,
      paintFill..color = Colors.white,
    );

    // Right bar clipped correctly - redraw blue bar right half only
    final barRect2 = Rect.fromLTRB(
      cx,
      cy - r * 0.19,
      cx + r * 1.05,
      cy + r * 0.19,
    );
    canvas.drawRect(barRect2, paintFill..color = const Color(0xFF4285F4));
    canvas.drawCircle(
      Offset(cx, cy),
      r * 0.58,
      paintFill..color = Colors.white,
    );
  }

  void _drawSector(
    Canvas canvas,
    double cx,
    double cy,
    double r,
    double startAngle,
    double endAngle,
    Color color,
    Paint paint,
  ) {
    paint.color = color;
    final path = Path()
      ..moveTo(cx, cy)
      ..arcTo(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        startAngle,
        endAngle - startAngle,
        false,
      )
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
