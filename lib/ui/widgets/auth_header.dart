// lib/ui/widgets/auth_header.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -40,
            child: CircleAvatar(radius: 80, backgroundColor: cs.onPrimary.withOpacity(0.06)),
          ),
          Positioned(
            left: 24,
            bottom: 36,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                      color: cs.onPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    )),
                const SizedBox(height: 6),
                Text(subtitle,
                    style: GoogleFonts.inter(
                      color: cs.onPrimary.withOpacity(0.9),
                      fontSize: 16,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}