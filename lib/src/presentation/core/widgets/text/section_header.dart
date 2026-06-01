import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            height: 1.2,
            color: Color(0xFF040707),
          ),
        ),
        if (subtitle != null) ...[
          const Gap(4),
          Text(
            subtitle!,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 13,
              color: Color(0xFF737780),
            ),
          ),
        ],
      ],
    );
  }
}
