import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/plant.dart';
import '../services/plant_service.dart';

class PlantProvider extends ChangeNotifier {
  final PlantService _plantService = PlantService();
  
  Plant? _currentPlant;
  List<Plant> _plantHistory = [];
  bool _isLoading = false;
  String? _error;
  File? _selectedImage;

  // Getters
  Plant? get currentPlant => _currentPlant;
  List<Plant> get plantHistory => _plantHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;
  File? get selectedImage => _selectedImage;

  PlantProvider() {
    _loadPlantHistory();
  }

  // Set selected image
  void setSelectedImage(File image) {
    _selectedImage = image;
    notifyListeners();
  }

  // Clear selected image
  void clearSelectedImage() {
    _selectedImage = null;
    notifyListeners();
  }

  // Analyze plant from image
  Future<void> analyzePlant(File imageFile) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Upload image and get analysis
      final plant = await _plantService.analyzePlant(imageFile);
      
      _currentPlant = plant;
      _addToHistory(plant);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Add plant to history
  void _addToHistory(Plant plant) {
    // Remove if already exists (update)
    _plantHistory.removeWhere((p) => p.id == plant.id);
    
    // Add to beginning of list
    _plantHistory.insert(0, plant);
    
    // Keep only last 50 entries
    if (_plantHistory.length > 50) {
      _plantHistory = _plantHistory.take(50).toList();
    }
    
    _savePlantHistory();
  }

  // Remove plant from history
  void removeFromHistory(String plantId) {
    _plantHistory.removeWhere((plant) => plant.id == plantId);
    _savePlantHistory();
  }

  // Clear history
  void clearHistory() {
    _plantHistory.clear();
    _savePlantHistory();
  }

  // Save history to local storage
  Future<void> _savePlantHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = _plantHistory.map((plant) => plant.toJson()).toList();
      await prefs.setString('plant_history', jsonEncode(historyJson));
    } catch (e) {
      debugPrint('Error saving plant history: $e');
    }
  }

  // Load history from local storage
  Future<void> _loadPlantHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyString = prefs.getString('plant_history');
      
      if (historyString != null) {
        final historyJson = jsonDecode(historyString) as List<dynamic>;
        _plantHistory = historyJson
            .map((json) => Plant.fromJson(json))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading plant history: $e');
    }
  }

  // Get plant by ID
  Plant? getPlantById(String id) {
    try {
      return _plantHistory.firstWhere((plant) => plant.id == id);
    } catch (e) {
      return null;
    }
  }

  // Clear current plant
  void clearCurrentPlant() {
    _currentPlant = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Get plants with diseases
  List<Plant> getPlantsWithDiseases() {
    return _plantHistory.where((plant) => plant.diseases.isNotEmpty).toList();
  }

  // Get plants by date range
  List<Plant> getPlantsByDateRange(DateTime start, DateTime end) {
    return _plantHistory
        .where((plant) => 
            plant.analyzedAt.isAfter(start) && 
            plant.analyzedAt.isBefore(end))
        .toList();
  }

  // Get recent plants (last 7 days)
  List<Plant> getRecentPlants() {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return _plantHistory
        .where((plant) => plant.analyzedAt.isAfter(weekAgo))
        .toList();
  }
}