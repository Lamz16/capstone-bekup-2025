import 'package:capstone/screen/chatbot/chatbot_screen.dart';
import 'package:capstone/screen/home/chatbot_icon.dart';
import 'package:capstone/screen/home/filter_modal.dart';
import 'package:capstone/widget/build_card.dart';
import 'package:capstone/widget/search_filter_header.dart';
import 'package:capstone/style/colors.dart';
import 'package:capstone/style/typography.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _currentSort = 'Terpopuler';
  Map<String, dynamic> _activeFilters = {};
  bool _showTitle = false;

  // Destination data
  late List<Map<String, dynamic>> _allDestinations;
  late List<Map<String, dynamic>> _filteredDestinations;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
    _initializeDestinations();
  }

  void _initializeDestinations() {
    _allDestinations = [
      {
        'id': 1,
        'name': 'Pantai Karangsong',
        'location': 'Karangsong, Indramayu',
        'province': 'Jawa Barat',
        'city': 'Indramayu',
        'rating': 4.5,
        'hours': '24 Jam',
        'price': 'Gratis',
        'distance': '2.3 km',
        'category': 'Pantai',
        'description':
            'Pantai indah dengan pasir putih dan ombak yang tenang, cocok untuk keluarga.',
        'image': 'assets/images/wisata.webp',
      },
      {
        'id': 2,
        'name': 'Museum Linggarjati',
        'location': 'Cilimus, Kuningan',
        'province': 'Jawa Barat',
        'city': 'Kuningan',
        'rating': 4.2,
        'hours': '08.00 - 16.00',
        'price': 'Rp 5.000',
        'distance': '15.2 km',
        'category': 'Museum',
        'description':
            'Museum bersejarah yang menyimpan peninggalan perjanjian Linggarjati.',
        'image': 'assets/images/wisata.webp',
      },
      {
        'id': 3,
        'name': 'Taman Sari Gua Sunyaragi',
        'location': 'Kesambi, Cirebon',
        'province': 'Jawa Barat',
        'city': 'Cirebon',
        'rating': 4.7,
        'hours': '08.00 - 17.00',
        'price': 'Rp 15.000',
        'distance': '8.5 km',
        'category': 'Sejarah',
        'description':
            'Kompleks gua buatan dengan arsitektur unik peninggalan Kesultanan Cirebon.',
        'image': 'assets/images/wisata.webp',
      },
      {
        'id': 4,
        'name': 'Gunung Ciremai',
        'location': 'Kuningan, Jawa Barat',
        'province': 'Jawa Barat',
        'city': 'Kuningan',
        'rating': 4.8,
        'hours': '24 Jam',
        'price': 'Rp 10.000',
        'distance': '25.0 km',
        'category': 'Gunung',
        'description':
            'Gunung tertinggi di Jawa Barat dengan pemandangan spektakuler.',
        'image': 'assets/images/wisata.webp',
      },
      {
        'id': 5,
        'name': 'Borobudur Temple',
        'location': 'Magelang, Jawa Tengah',
        'province': 'Jawa Tengah',
        'city': 'Magelang',
        'rating': 4.9,
        'hours': '06.00 - 17.00',
        'price': 'Rp 50.000',
        'distance': '150.0 km',
        'category': 'Sejarah',
        'description':
            'Candi Buddha terbesar di dunia, situs warisan dunia UNESCO.',
        'image': 'assets/images/wisata.webp',
      },
      {
        'id': 6,
        'name': 'Malioboro Street',
        'location': 'Yogyakarta',
        'province': 'DI Yogyakarta',
        'city': 'Yogyakarta',
        'rating': 4.3,
        'hours': '24 Jam',
        'price': 'Gratis',
        'distance': '200.0 km',
        'category': 'Kuliner',
        'description':
            'Jalan utama di Yogyakarta dengan berbagai kuliner dan souvenir.',
        'image': 'assets/images/wisata.webp',
      },
    ];
    _filteredDestinations = List.from(_allDestinations);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    const threshold = 200.0;
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
      backgroundColor: isDarkMode
          ? theme.scaffoldBackgroundColor
          : AppColors.whiteSoft,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // AppBar dengan theme colors
          SliverAppBar(
            pinned: true,
            floating: false,
            snap: false,
            backgroundColor: AppColors.oceanBlue,
            expandedHeight: 175.0,
            title: AnimatedOpacity(
              opacity: _showTitle ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                "WisataKu",
                style: AppTypography.heading2.copyWith(color: Colors.white),
              ),
            ),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    "assets/images/beautiful-diamond-beach-penida-island-bali-indonesia.jpg",
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.black.withOpacity(0.1),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Temukan Rekomendasi",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Destinasi Wisata di Sekitarmu",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Tambahkan settings button
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: AppColors.navy,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
              ),
            ],
          ),

          // Search & Filter dengan theme colors
          SliverPersistentHeader(
            pinned: true,
            delegate: SearchFilterHeader(
              searchController: _searchController,
              onFilterTap: _showFilterModal,
              theme: theme,
              scrollOffset: _scrollController.hasClients
                  ? _scrollController.offset
                  : 0.0,
              // hasActiveFilter:
              //     _activeFilters.isNotEmpty || _currentSort.isNotEmpty,
            ),
          ),

          // Tourism Cards List dengan theme
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: buildCard(
                    context,
                    _filteredDestinations[index],
                    theme: theme,
                    isDarkMode: isDarkMode,
                  ),
                ),
                childCount: _filteredDestinations.length,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ChatBotIcon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatbotScreen()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    String searchText = _searchController.text.toLowerCase();

    List<Map<String, dynamic>> filtered = _allDestinations.where((destination) {
      // Search filter: check if search text is in name, location, category, or description
      bool matchesSearch =
          searchText.isEmpty ||
          destination['name'].toString().toLowerCase().contains(searchText) ||
          destination['location'].toString().toLowerCase().contains(
            searchText,
          ) ||
          destination['category'].toString().toLowerCase().contains(
            searchText,
          ) ||
          destination['description'].toString().toLowerCase().contains(
            searchText,
          );

      if (!matchesSearch) return false;

      // Filter by active filters
      if (_activeFilters.isNotEmpty) {
        // Province filter
        if (_activeFilters.containsKey('province') &&
            destination['province'] != _activeFilters['province']) {
          return false;
        }
        // City filter
        if (_activeFilters.containsKey('city') &&
            destination['city'] != _activeFilters['city']) {
          return false;
        }
        // Category filter
        if (_activeFilters.containsKey('category') &&
            destination['category'] != _activeFilters['category']) {
          return false;
        }
        // Minimum rating filter
        if (_activeFilters.containsKey('min_rating')) {
          double minRating = _activeFilters['min_rating'];
          if (destination['rating'] < minRating) {
            return false;
          }
        }
        // Price range filter
        if (_activeFilters.containsKey('price_range')) {
          String priceRange = _activeFilters['price_range'];
          if (!_priceRangeMatches(destination['price'], priceRange)) {
            return false;
          }
        }
        // Max distance filter
        if (_activeFilters.containsKey('max_distance')) {
          double maxDistance = _activeFilters['max_distance'];
          double distance = _parseDistance(destination['distance']);
          if (distance > maxDistance) {
            return false;
          }
        }
      }

      return true;
    }).toList();

    // Apply sorting
    filtered.sort(_sortComparator);

    setState(() {
      _filteredDestinations = filtered;
    });
  }

  bool _priceRangeMatches(String price, String range) {
    if (range == 'Gratis') {
      return price.toLowerCase() == 'gratis';
    } else if (range == '< Rp 10.000') {
      double? priceValue = _parsePrice(price);
      return priceValue != null && priceValue < 10000;
    } else if (range == 'Rp 10.000 - Rp 50.000') {
      double? priceValue = _parsePrice(price);
      return priceValue != null && priceValue >= 10000 && priceValue <= 50000;
    } else if (range == 'Rp 50.000 - Rp 100.000') {
      double? priceValue = _parsePrice(price);
      return priceValue != null && priceValue > 50000 && priceValue <= 100000;
    } else if (range == '> Rp 100.000') {
      double? priceValue = _parsePrice(price);
      return priceValue != null && priceValue > 100000;
    }
    return true;
  }

  double? _parsePrice(String price) {
    try {
      String cleaned = price.replaceAll(RegExp(r'[^0-9]'), '');
      return double.tryParse(cleaned);
    } catch (e) {
      return null;
    }
  }

  double _parseDistance(String distance) {
    try {
      String cleaned = distance.toLowerCase().replaceAll(
        RegExp(r'[^0-9.]'),
        '',
      );
      return double.parse(cleaned);
    } catch (e) {
      return double.infinity;
    }
  }

  int _sortComparator(Map<String, dynamic> a, Map<String, dynamic> b) {
    switch (_currentSort) {
      case 'Terpopuler':
        // Sort by rating descending
        return b['rating'].compareTo(a['rating']);
      case 'Terdekat':
        // Sort by distance ascending
        return _parseDistance(
          a['distance'],
        ).compareTo(_parseDistance(b['distance']));
      case 'Rating Tertinggi':
        // Sort by rating descending
        return b['rating'].compareTo(a['rating']);
      case 'Harga Termurah':
        // Sort by price ascending
        double aPrice = _parsePrice(a['price']) ?? double.infinity;
        double bPrice = _parsePrice(b['price']) ?? double.infinity;
        return aPrice.compareTo(bPrice);
      case 'Harga Termahal':
        // Sort by price descending
        double aPrice = _parsePrice(a['price']) ?? 0;
        double bPrice = _parsePrice(b['price']) ?? 0;
        return bPrice.compareTo(aPrice);
      default:
        return 0;
    }
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor, // Gunakan theme color
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterModal(
        activeFilters: _activeFilters,
        currentSort: _currentSort,
        onFiltersChanged: (filters, sort) {
          setState(() {
            _activeFilters = filters;
            _currentSort = sort ?? _currentSort;
            _applyFilters();
          });
        },
      ),
    );
  }
}
