import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../utils/theme.dart';

class CareStepCard extends StatelessWidget {
  final CareStep step;

  const CareStepCard({
    super.key,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
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
          border: Border.all(
            color: _getPriorityColor().withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _getCategoryText(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
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
                    color: _getPriorityColor(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Priority ${step.priority}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Description
            Text(
              step.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            
            // Materials
            if (step.materials.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Materials needed:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: step.materials.map((material) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryGreen.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    material,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor() {
    switch (step.priority) {
      case 1:
        return AppTheme.errorRed;
      case 2:
        return AppTheme.warningOrange;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.yellow.shade700;
      case 5:
        return AppTheme.primaryGreen;
      default:
        return AppTheme.warningOrange;
    }
  }

  IconData _getCategoryIcon() {
    switch (step.category.toLowerCase()) {
      case 'immediate':
        return Icons.emergency;
      case 'daily':
        return Icons.today;
      case 'weekly':
        return Icons.view_week;
      case 'monthly':
        return Icons.calendar_month;
      default:
        return Icons.check_circle;
    }
  }

  String _getCategoryText() {
    switch (step.category.toLowerCase()) {
      case 'immediate':
        return 'Do immediately';
      case 'daily':
        return 'Daily care';
      case 'weekly':
        return 'Weekly care';
      case 'monthly':
        return 'Monthly care';
      default:
        return 'Regular care';
    }
  }
}