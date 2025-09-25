import 'package:capstone/model/tourism_recommendation.dart';
import 'package:capstone/provider/favorite_provider.dart';
import 'package:capstone/screen/detail/detail_page.dart';
import 'package:capstone/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget buildCard(
  BuildContext context,
  int index, {
  required ThemeData theme,
  bool isDarkMode = false,
}) {
  final isDarkMode = theme.brightness == Brightness.dark;
  final destinations = [
    {
      'id': 1,
      'name': 'Pantai Karangsong',
      'location': 'Karangsong, Indramayu',
      'rating': 4.5,
      'hours': '24 Jam',
      'price': 'Gratis',
      'distance': '2.3 km',
      'category': 'Pantai',
      'description':
          'Pantai indah dengan pasir putih dan ombak yang tenang, cocok untuk keluarga.',
    },
    {
      'id': 2,
      'name': 'Museum Linggarjati',
      'location': 'Cilimus, Kuningan',
      'rating': 4.2,
      'hours': '08.00 - 16.00',
      'price': 'Rp 5.000',
      'distance': '15.2 km',
      'category': 'Museum',
      'description':
          'Museum bersejarah yang menyimpan peninggalan perjanjian Linggarjati.',
    },
    {
      'id': 3,
      'name': 'Taman Sari Gua Sunyaragi',
      'location': 'Kesambi, Cirebon',
      'rating': 4.7,
      'hours': '08.00 - 17.00',
      'price': 'Rp 15.000',
      'distance': '8.5 km',
      'category': 'Sejarah',
      'description':
          'Kompleks gua buatan dengan arsitektur unik peninggalan Kesultanan Cirebon.',
    },
  ];

  final destination = destinations[index % destinations.length];

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailScreen(destination: destination),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: isDarkMode ? theme.cardColor : Colors.white70,
        borderRadius: BorderRadius.circular(16),
        border: isDarkMode
            ? Border.all(
                color: AppColors.whiteSoft.withOpacity(
                  0.5,
                ), // ⬅️ border whiteSoft pas dark
                width: 0.5,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Container(
                  height: 160,
                  width: double.infinity,
                  child: Image.asset(
                    "assets/images/wisata.webp",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Category badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.oceanBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    destination['category'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // Distance badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        destination['distance'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Favorite button
              Positioned(
                bottom: 12,
                right: 12,
                child: Consumer<FavoriteProvider>(
                  builder: (context, favoriteProvider, child) {
                    final isFavorite = favoriteProvider.isFavorite(
                      destination['name'] as String,
                    );

                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          // Create TourismRecommendation object from destination data
                          final tourismItem = TourismRecommendation(
                            name: destination['name'] as String,
                            type: RecommendationType.wisata,
                            description: destination['description'] as String,
                            distance: destination['distance'] as String,
                            rating: destination['rating'].toString(),
                            address: destination['location'] as String,
                            priceRange: destination['price'] as String,
                            openHours: destination['hours'] as String,
                          );

                          // Toggle favorite status
                          await favoriteProvider.toggleFavorite(tourismItem);

                          // Show feedback
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isFavorite
                                    ? 'Dihapus dari favorit'
                                    : 'Ditambahkan ke favorit',
                              ),
                              backgroundColor: isFavorite
                                  ? AppColors.error
                                  : AppColors.oceanBlue,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey.shade600,
                          size: 18,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Content section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and rating row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            destination['name'] as String,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.place,
                                size: 14,
                                color: theme.textTheme.bodyMedium?.color
                                    ?.withOpacity(0.7),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  destination['location'] as String,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.textTheme.bodyMedium?.color
                                        ?.withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.orange.shade600,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${destination['rating']}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Description
                Text(
                  destination['description'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.8),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Info chips row
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _buildInfoChip(
                      Icons.access_time,
                      destination['hours'] as String,
                      theme: theme,
                    ),
                    _buildInfoChip(
                      Icons.payments,
                      destination['price'] as String,
                      theme: theme,
                    ),
                    _buildInfoChip(
                      Icons.location_on,
                      destination['distance'] as String,
                      theme: theme,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildInfoChip(IconData icon, String text, {required ThemeData theme}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    decoration: BoxDecoration(
      color: theme.brightness == Brightness.dark
          ? Colors.grey.shade800
          : Colors.grey.shade100,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
