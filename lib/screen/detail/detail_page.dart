import 'package:capstone/widget/header_section.dart';
import 'package:capstone/widget/info_card.dart';
import 'package:capstone/widget/nav_icon.dart';
import 'package:capstone/widget/review_widget.dart';
import 'package:capstone/style/colors.dart';
import 'package:flutter/material.dart';

final List<String> sampleImages = [
  "assets/images/wisata.webp",
  "assets/images/wisata.webp",
  "assets/images/wisata.webp",
  "assets/images/wisata.webp",
];

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> destination;

  const DetailScreen({super.key, required this.destination});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with TickerProviderStateMixin {
  bool isFavorite = false;
  int selectedImageIndex = 0;
  bool _showTitle = false;
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    const threshold = 300.0;
    if (_scrollController.hasClients) {
      final showTitle = _scrollController.offset > threshold;
      if (showTitle != _showTitle) {
        setState(() {
          _showTitle = showTitle;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan theme dari context
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor, // Gunakan theme background
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: theme.cardColor, // Gunakan card color dari theme
            elevation: 0,
            title: AnimatedOpacity(
              opacity: _showTitle ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                widget.destination['name'] ?? 'Detail Destinasi',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: isDarkMode ? Colors.white : AppColors.navy,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            centerTitle: true,
            leading: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.cardColor.withOpacity(
                  0.9,
                ), // Gunakan theme card color
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: isDarkMode ? Colors.white : AppColors.navy,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.cardColor.withOpacity(
                    0.9,
                  ), // Gunakan theme card color
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite
                          ? Colors.red
                          : (isDarkMode ? Colors.white : AppColors.navy),
                      key: ValueKey(isFavorite),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Image Gallery - tidak perlu diubah
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        selectedImageIndex = index;
                      });
                    },
                    itemCount: sampleImages.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        sampleImages[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.3, 0.7, 1.0],
                      ),
                    ),
                  ),
                  // Image indicators
                  Positioned(
                    bottom: 100,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: sampleImages.asMap().entries.map((entry) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: selectedImageIndex == entry.key ? 24 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: selectedImageIndex == entry.key
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  // Category Badge
                  Positioned(
                    top: 100,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.oceanBlue,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.destination['category'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content dengan theme colors
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? theme.cardColor : AppColors.whiteSoft,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: isDarkMode
                          ? AppColors.whiteSoft
                          : AppColors.oceanBlue,
                      width: 1,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildHeaderSection(widget.destination, theme: theme),
                      const SizedBox(height: 24),
                      buildQuickInfoGrid(widget.destination, theme: theme),
                      const SizedBox(height: 32),
                      buildDescriptionSection(widget.destination, theme: theme),
                      const SizedBox(height: 32),
                      buildFacilitiesSection(theme: theme),
                      const SizedBox(height: 32),
                      buildReviewsSection(theme: theme),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardColor, // Gunakan card color dari theme
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Row(
          children: [
            // Share Button dengan theme colors
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.oceanBlue.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(16),
                color: theme.scaffoldBackgroundColor,
              ),
              child: IconButton(
                onPressed: () {
                  _showShareOptions();
                },
                icon: Icon(Icons.share_outlined, color: AppColors.oceanBlue),
              ),
            ),
            const SizedBox(width: 16),

            // Navigate Button - tetap sama
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.oceanBlue,
                      AppColors.oceanBlue.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.oceanBlue.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showNavigationOptions();
                  },
                  icon: const Icon(Icons.navigation, color: Colors.white),
                  label: const Text(
                    'Navigasi ke Lokasi',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modal methods dengan theme
  void _showShareOptions() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Bagikan Destinasi",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildShareIcon(Icons.copy, "Salin", theme: theme),
                buildShareIcon(Icons.call, "WhatsApp", theme: theme),
                buildShareIcon(Icons.mail_outline, "Email", theme: theme),
                buildShareIcon(Icons.facebook, "Facebook", theme: theme),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Salin link atau bagikan ke media sosial",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNavigationOptions() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Navigasi ke Lokasi",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildNavIcon(Icons.location_on, "Google Maps", theme: theme),
                buildNavIcon(Icons.directions, "Waze", theme: theme),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Pilih aplikasi navigasi favoritmu",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
