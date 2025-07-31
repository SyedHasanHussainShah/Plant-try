class Plant {
  final String id;
  final String name;
  final String scientificName;
  final String commonName;
  final double confidence;
  final String imageUrl;
  final List<Disease> diseases;
  final CarePrescription carePrescription;
  final DateTime analyzedAt;

  Plant({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.commonName,
    required this.confidence,
    required this.imageUrl,
    required this.diseases,
    required this.carePrescription,
    required this.analyzedAt,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      scientificName: json['scientificName'] ?? '',
      commonName: json['commonName'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      diseases: (json['diseases'] as List<dynamic>?)
          ?.map((disease) => Disease.fromJson(disease))
          .toList() ?? [],
      carePrescription: CarePrescription.fromJson(json['carePrescription'] ?? {}),
      analyzedAt: DateTime.parse(json['analyzedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scientificName': scientificName,
      'commonName': commonName,
      'confidence': confidence,
      'imageUrl': imageUrl,
      'diseases': diseases.map((disease) => disease.toJson()).toList(),
      'carePrescription': carePrescription.toJson(),
      'analyzedAt': analyzedAt.toIso8601String(),
    };
  }

  Plant copyWith({
    String? id,
    String? name,
    String? scientificName,
    String? commonName,
    double? confidence,
    String? imageUrl,
    List<Disease>? diseases,
    CarePrescription? carePrescription,
    DateTime? analyzedAt,
  }) {
    return Plant(
      id: id ?? this.id,
      name: name ?? this.name,
      scientificName: scientificName ?? this.scientificName,
      commonName: commonName ?? this.commonName,
      confidence: confidence ?? this.confidence,
      imageUrl: imageUrl ?? this.imageUrl,
      diseases: diseases ?? this.diseases,
      carePrescription: carePrescription ?? this.carePrescription,
      analyzedAt: analyzedAt ?? this.analyzedAt,
    );
  }
}

class Disease {
  final String name;
  final String description;
  final double confidence;
  final String severity; // 'low', 'medium', 'high', 'critical'
  final List<String> symptoms;
  final String treatment;

  Disease({
    required this.name,
    required this.description,
    required this.confidence,
    required this.severity,
    required this.symptoms,
    required this.treatment,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      severity: json['severity'] ?? 'low',
      symptoms: List<String>.from(json['symptoms'] ?? []),
      treatment: json['treatment'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'confidence': confidence,
      'severity': severity,
      'symptoms': symptoms,
      'treatment': treatment,
    };
  }
}

class CarePrescription {
  final String summary;
  final List<CareStep> steps;
  final String watering;
  final String sunlight;
  final String soil;
  final String fertilizer;
  final List<String> warnings;
  final DateTime nextCheckup;

  CarePrescription({
    required this.summary,
    required this.steps,
    required this.watering,
    required this.sunlight,
    required this.soil,
    required this.fertilizer,
    required this.warnings,
    required this.nextCheckup,
  });

  factory CarePrescription.fromJson(Map<String, dynamic> json) {
    return CarePrescription(
      summary: json['summary'] ?? '',
      steps: (json['steps'] as List<dynamic>?)
          ?.map((step) => CareStep.fromJson(step))
          .toList() ?? [],
      watering: json['watering'] ?? '',
      sunlight: json['sunlight'] ?? '',
      soil: json['soil'] ?? '',
      fertilizer: json['fertilizer'] ?? '',
      warnings: List<String>.from(json['warnings'] ?? []),
      nextCheckup: DateTime.parse(json['nextCheckup'] ?? DateTime.now().add(const Duration(days: 7)).toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'steps': steps.map((step) => step.toJson()).toList(),
      'watering': watering,
      'sunlight': sunlight,
      'soil': soil,
      'fertilizer': fertilizer,
      'warnings': warnings,
      'nextCheckup': nextCheckup.toIso8601String(),
    };
  }
}

class CareStep {
  final String title;
  final String description;
  final String category; // 'immediate', 'daily', 'weekly', 'monthly'
  final int priority; // 1-5, where 1 is highest priority
  final List<String> materials;

  CareStep({
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.materials,
  });

  factory CareStep.fromJson(Map<String, dynamic> json) {
    return CareStep(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'daily',
      priority: json['priority'] ?? 3,
      materials: List<String>.from(json['materials'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'materials': materials,
    };
  }
}