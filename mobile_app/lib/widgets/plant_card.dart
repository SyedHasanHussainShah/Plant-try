import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../utils/theme.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;

  const PlantCard({
    super.key,
    required this.plant,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiseases = plant.diseases.isNotEmpty;
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Row(
          children: [
            // Plant Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: hasDiseases 
                    ? AppTheme.warningOrange.withOpacity(0.1)
                    : AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                hasDiseases ? Icons.healing : Icons.eco,
                color: hasDiseases ? AppTheme.warningOrange : AppTheme.primaryGreen,
                size: 30,
              ),
            ),
            
            const SizedBox(width: 15),
            
            // Plant Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          plant.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: hasDiseases 
                              ? AppTheme.warningOrange.withOpacity(0.1)
                              : AppTheme.successGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          hasDiseases ? 'Needs Care' : 'Healthy',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: hasDiseases ? AppTheme.warningOrange : AppTheme.successGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    plant.scientificName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      Icon(
                        Icons.psychology,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${(plant.confidence * 100).toInt()}% confidence',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(plant.analyzedAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  
                  if (hasDiseases) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.warning,
                          size: 16,
                          color: AppTheme.warningOrange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${plant.diseases.length} disease${plant.diseases.length > 1 ? 's' : ''} detected',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.warningOrange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            
            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
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