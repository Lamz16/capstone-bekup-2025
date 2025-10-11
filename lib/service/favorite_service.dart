import 'package:capstone/model/tourism_recommendation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteService {
  static const String _favoritesKey = 'user_favorites';

  Future<List<TourismRecommendation>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];

      return favoritesJson.map((json) {
        final Map<String, dynamic> data = jsonDecode(json);
        return TourismRecommendation.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting favorites: $e');
      return [];
    }
  }

  Future<bool> addToFavorites(TourismRecommendation item) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];

      // Check if item already exists
      final existingIndex = favoritesJson.indexWhere((json) {
        final Map<String, dynamic> data = jsonDecode(json);
        return data['name'] == item.name;
      });

      if (existingIndex != -1) {
        return true; 
      }

      // Add new item
      final itemJson = jsonEncode(item.toJson());
      favoritesJson.add(itemJson);

      return await prefs.setStringList(_favoritesKey, favoritesJson);
    } catch (e) {
      print('Error adding to favorites: $e');
      return false;
    }
  }

  Future<bool> removeFromFavorites(String itemName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];

      // Remove item by name
      favoritesJson.removeWhere((json) {
        final Map<String, dynamic> data = jsonDecode(json);
        return data['name'] == itemName;
      });

      return await prefs.setStringList(_favoritesKey, favoritesJson);
    } catch (e) {
      print('Error removing from favorites: $e');
      return false;
    }
  }

  Future<bool> clearAllFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_favoritesKey);
    } catch (e) {
      print('Error clearing favorites: $e');
      return false;
    }
  }

  Future<bool> isFavorite(String itemName) async {
    try {
      final favorites = await getFavorites();
      return favorites.any((item) => item.name == itemName);
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }
}
