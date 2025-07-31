import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/plant_provider.dart';
import '../utils/theme.dart';
import '../widgets/disease_card.dart';
import '../widgets/care_step_card.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plantProvider = Provider.of<PlantProvider>(context);
    final plant = plantProvider.currentPlant;

    if (plant == null) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundGreen,
        appBar: AppBar(
          title: const Text('Analysis Results'),
          backgroundColor: AppTheme.primaryGreen,
        ),
        body: const Center(
          child: Text('No plant data available'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundGreen,
      appBar: AppBar(
        title: const Text('Analysis Results'),
        backgroundColor: AppTheme.primaryGreen,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Share results
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant Identification Card
            _buildPlantIdentificationCard(plant),
            
            const SizedBox(height: 20),
            
            // Diseases Section
            if (plant.diseases.isNotEmpty) ...[
              _buildDiseasesSection(plant),
              const SizedBox(height: 20),
            ],
            
            // Care Prescription Section
            _buildCarePrescriptionSection(plant),
            
            const SizedBox(height: 30),
            
            // Action Buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantIdentificationCard(plant) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryGreen,
              AppTheme.accentGreen,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.eco,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.name,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        plant.scientificName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.psychology,
                    title: 'Confidence',
                    value: '${(plant.confidence * 100).toInt()}%',
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.calendar_today,
                    title: 'Analyzed',
                    value: _formatDate(plant.analyzedAt),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDiseasesSection(plant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Disease Detection',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: plant.diseases.length,
          itemBuilder: (context, index) {
            return DiseaseCard(disease: plant.diseases[index]);
          },
        ),
      ],
    );
  }

  Widget _buildCarePrescriptionSection(plant) {
    final prescription = plant.carePrescription;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Care Prescription',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        
        // Summary Card
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppTheme.surfaceGreen,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.healing,
                      color: AppTheme.primaryGreen,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Summary',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  prescription.summary,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Care Steps
        Text(
          'Treatment Steps',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: prescription.steps.length,
          itemBuilder: (context, index) {
            return CareStepCard(step: prescription.steps[index]);
          },
        ),
        
        const SizedBox(height: 20),
        
        // Care Requirements
        _buildCareRequirements(prescription),
        
        const SizedBox(height: 20),
        
        // Warnings
        if (prescription.warnings.isNotEmpty) ...[
          _buildWarningsSection(prescription),
          const SizedBox(height: 20),
        ],
        
        // Next Checkup
        _buildNextCheckupCard(prescription),
      ],
    );
  }

  Widget _buildCareRequirements(prescription) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Care Requirements',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            
            _buildRequirementItem(
              icon: Icons.water_drop,
              title: 'Watering',
              description: prescription.watering,
            ),
            
            const SizedBox(height: 15),
            
            _buildRequirementItem(
              icon: Icons.wb_sunny,
              title: 'Sunlight',
              description: prescription.sunlight,
            ),
            
            const SizedBox(height: 15),
            
            _buildRequirementItem(
              icon: Icons.landscape,
              title: 'Soil',
              description: prescription.soil,
            ),
            
            const SizedBox(height: 15),
            
            _buildRequirementItem(
              icon: Icons.grass,
              title: 'Fertilizer',
              description: prescription.fertilizer,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppTheme.primaryGreen,
          size: 20,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWarningsSection(prescription) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppTheme.warningOrange.withOpacity(0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning,
                  color: AppTheme.warningOrange,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  'Important Warnings',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.warningOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            
            ...prescription.warnings.map((warning) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.warningOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      warning,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildNextCheckupCard(prescription) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.accentGreen,
              AppTheme.primaryGreen,
            ],
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.schedule,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Next Checkup',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    _formatDate(prescription.nextCheckup),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.camera_alt),
            label: const Text('Analyze Another'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Save to favorites
            },
            icon: const Icon(Icons.favorite_border),
            label: const Text('Save'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}