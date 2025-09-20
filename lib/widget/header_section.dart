import 'package:capstone/widget/info_card.dart';
import 'package:capstone/style/colors.dart';
import 'package:capstone/style/typography.dart';
import 'package:flutter/material.dart';

Widget buildHeaderSection(
  Map<String, dynamic> destination, {
  required ThemeData theme,
}) {
  final isDark = theme.brightness == Brightness.dark;

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              destination['name'],
              style: AppTypography.heading.copyWith(
                color: isDark ? AppColors.whiteSoft : AppColors.navy,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 18, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    destination['location'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade400, Colors.orange.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: Colors.white, size: 22),
                const SizedBox(width: 6),
                Text(
                  '${destination['rating']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              "Rating",
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget buildQuickInfoGrid(
  Map<String, dynamic> destination, {
  required ThemeData theme,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      buildInfoCard(
        Icons.access_time,
        destination['hours'],
        "Jam Operasional",
        theme,
      ),
      buildInfoCard(Icons.payments, destination['price'], "Harga", theme),
      buildInfoCard(Icons.location_on, destination['distance'], "Jarak", theme),
    ],
  );
}
