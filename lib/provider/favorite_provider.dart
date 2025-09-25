import 'package:capstone/model/tourism_recommendation.dart';
import 'package:capstone/service/favorite_service.dart';
import 'package:flutter/foundation.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteService _favoriteService = FavoriteService();
  List<TourismRecommendation> _favorites = [];
  bool _isLoading = false;

  List<TourismRecommendation> get favorites => _favorites;
  bool get isLoading => _isLoading;

  FavoriteProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await _favoriteService.getFavorites();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      _favorites = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToFavorites(TourismRecommendation item) async {
    try {
      final success = await _favoriteService.addToFavorites(item);
      if (success) {
        _favorites.add(item);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error adding to favorites: $e');
      return false;
    }
  }

  Future<bool> removeFromFavorites(String itemName) async {
    try {
      final success = await _favoriteService.removeFromFavorites(itemName);
      if (success) {
        _favorites.removeWhere((item) => item.name == itemName);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error removing from favorites: $e');
      return false;
    }
  }

  bool isFavorite(String itemName) {
    return _favorites.any((item) => item.name == itemName);
  }

  Future<void> toggleFavorite(TourismRecommendation item) async {
    if (isFavorite(item.name)) {
      await removeFromFavorites(item.name);
    } else {
      await addToFavorites(item);
    }
  }

  Future<void> clearAllFavorites() async {
    try {
      final success = await _favoriteService.clearAllFavorites();
      if (success) {
        _favorites.clear();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error clearing favorites: $e');
    }
  }

  int get favoriteCount => _favorites.length;
}
