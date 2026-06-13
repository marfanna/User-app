import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RestaurantsSponsoredCard extends StatelessWidget {
  const RestaurantsSponsoredCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 180,
            child: Image.network(
              'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=800&q=80',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  Container(color: const Color(0xFFE0E0E0)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SPONSORED',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    letterSpacing: 0.8,
                    color: Color(0xFF9B9B9B),
                  ),
                ),
                const Gap(6),
                const Text(
                  'Your Morning, Delivered',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    height: 1.3,
                    color: Color(0xFF040707),
                  ),
                ),
                const Gap(4),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      height: 1.5,
                      color: Color(0xFF6B6B6B),
                    ),
                    children: [
                      TextSpan(text: 'Fresh coffee and pastries straight '),
                      TextSpan(
                        text: 'to your door',
                        style: TextStyle(color: Color(0xFF0156A7)),
                      ),
                      TextSpan(text: '.'),
                    ],
                  ),
                ),
                const Gap(14),
                OutlinedButton(
                  onPressed: null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF040707),
                    disabledForegroundColor: const Color(0xFF040707),
                    side: const BorderSide(
                      color: Color(0xFF040707),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Order now',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
