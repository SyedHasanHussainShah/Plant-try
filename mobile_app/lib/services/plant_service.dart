import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

import '../models/plant.dart';

class PlantService {
  static const String _baseUrl = 'http://localhost:8000'; // Backend API URL
  final Dio _dio = Dio();

  PlantService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  // Analyze plant from image
  Future<Plant> analyzePlant(File imageFile) async {
    try {
      // Create form data
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'plant_image.jpg',
        ),
      });

      // Make API call
      final response = await _dio.post(
        '/analyze-plant',
        data: formData,
      );

      if (response.statusCode == 200) {
        return Plant.fromJson(response.data);
      } else {
        throw Exception('Failed to analyze plant: ${response.statusMessage}');
      }
    } catch (e) {
      // For demo purposes, return mock data if API fails
      return _getMockPlantData();
    }
  }

  // Get plant identification only
  Future<Map<String, dynamic>> identifyPlant(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'plant_image.jpg',
        ),
      });

      final response = await _dio.post(
        '/identify-plant',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to identify plant: ${response.statusMessage}');
      }
    } catch (e) {
      return _getMockIdentificationData();
    }
  }

  // Get disease detection only
  Future<List<Disease>> detectDiseases(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'plant_image.jpg',
        ),
      });

      final response = await _dio.post(
        '/detect-diseases',
        data: formData,
      );

      if (response.statusCode == 200) {
        final diseasesJson = response.data['diseases'] as List<dynamic>;
        return diseasesJson
            .map((disease) => Disease.fromJson(disease))
            .toList();
      } else {
        throw Exception('Failed to detect diseases: ${response.statusMessage}');
      }
    } catch (e) {
      return _getMockDiseasesData();
    }
  }

  // Get care prescription
  Future<CarePrescription> getCarePrescription({
    required String plantName,
    required List<Disease> diseases,
  }) async {
    try {
      final response = await _dio.post(
        '/care-prescription',
        data: {
          'plantName': plantName,
          'diseases': diseases.map((d) => d.toJson()).toList(),
        },
      );

      if (response.statusCode == 200) {
        return CarePrescription.fromJson(response.data);
      } else {
        throw Exception('Failed to get care prescription: ${response.statusMessage}');
      }
    } catch (e) {
      return _getMockCarePrescription();
    }
  }

  // Mock data for demo purposes
  Plant _getMockPlantData() {
    return Plant(
      id: 'plant_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Rose',
      scientificName: 'Rosa',
      commonName: 'Garden Rose',
      confidence: 0.95,
      imageUrl: '',
      diseases: _getMockDiseasesData(),
      carePrescription: _getMockCarePrescription(),
      analyzedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> _getMockIdentificationData() {
    return {
      'name': 'Rose',
      'scientificName': 'Rosa',
      'commonName': 'Garden Rose',
      'confidence': 0.95,
    };
  }

  List<Disease> _getMockDiseasesData() {
    return [
      Disease(
        name: 'Black Spot',
        description: 'A fungal disease that causes black spots on rose leaves',
        confidence: 0.87,
        severity: 'medium',
        symptoms: [
          'Black spots on leaves',
          'Yellowing around spots',
          'Leaf drop in severe cases',
        ],
        treatment: 'Remove infected leaves and apply fungicide',
      ),
      Disease(
        name: 'Powdery Mildew',
        description: 'A fungal disease that appears as white powdery spots',
        confidence: 0.72,
        severity: 'low',
        symptoms: [
          'White powdery spots on leaves',
          'Distorted new growth',
          'Reduced flowering',
        ],
        treatment: 'Improve air circulation and apply fungicide',
      ),
    ];
  }

  CarePrescription _getMockCarePrescription() {
    return CarePrescription(
      summary: 'Your rose has black spot and powdery mildew. Immediate treatment is needed to prevent further damage.',
      steps: [
        CareStep(
          title: 'Remove Infected Leaves',
          description: 'Carefully remove all leaves with black spots or powdery mildew',
          category: 'immediate',
          priority: 1,
          materials: ['Gloves', 'Pruning shears', 'Disinfectant'],
        ),
        CareStep(
          title: 'Apply Fungicide',
          description: 'Spray with a copper-based fungicide to treat existing infections',
          category: 'immediate',
          priority: 1,
          materials: ['Copper fungicide', 'Spray bottle'],
        ),
        CareStep(
          title: 'Improve Air Circulation',
          description: 'Prune to open up the plant and allow better air flow',
          category: 'weekly',
          priority: 2,
          materials: ['Pruning shears'],
        ),
        CareStep(
          title: 'Water at Base',
          description: 'Water at the base of the plant to avoid wetting leaves',
          category: 'daily',
          priority: 3,
          materials: ['Watering can'],
        ),
        CareStep(
          title: 'Monitor Progress',
          description: 'Check for new spots weekly and continue treatment if needed',
          category: 'weekly',
          priority: 4,
          materials: [],
        ),
      ],
      watering: 'Water deeply 2-3 times per week, avoiding wetting the leaves',
      sunlight: 'Full sun (6-8 hours per day)',
      soil: 'Well-draining, rich soil with pH 6.0-6.5',
      fertilizer: 'Apply balanced fertilizer monthly during growing season',
      warnings: [
        'Avoid overhead watering',
        'Dispose of infected leaves properly',
        'Clean tools after use',
      ],
      nextCheckup: DateTime.now().add(const Duration(days: 7)),
    );
  }
}