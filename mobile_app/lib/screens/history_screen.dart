import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/plant_provider.dart';
import '../utils/theme.dart';
import '../widgets/plant_card.dart';
import 'results_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'all';
  final List<String> _filters = [
    'all',
    'healthy',
    'needs_care',
    'recent',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGreen,
      appBar: AppBar(
        title: const Text('Plant History'),
        backgroundColor: AppTheme.primaryGreen,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All Plants'),
              ),
              const PopupMenuItem(
                value: 'healthy',
                child: Text('Healthy Plants'),
              ),
              const PopupMenuItem(
                value: 'needs_care',
                child: Text('Needs Care'),
              ),
              const PopupMenuItem(
                value: 'recent',
                child: Text('Recent'),
              ),
            ],
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.filter_list),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          _buildFilterChips(),
          
          // Plant List
          Expanded(
            child: _buildPlantList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Container(
              margin: const EdgeInsets.only(right: 12),
              child: FilterChip(
                label: Text(_getFilterLabel(filter)),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
                backgroundColor: Colors.white,
                selectedColor: AppTheme.primaryGreen.withOpacity(0.2),
                checkmarkColor: AppTheme.primaryGreen,
                labelStyle: TextStyle(
                  color: isSelected ? AppTheme.primaryGreen : AppTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPlantList() {
    final plantProvider = Provider.of<PlantProvider>(context);
    final plants = _getFilteredPlants(plantProvider);

    if (plants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 20),
            Text(
              'No plants found',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start by analyzing your first plant!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: plants.length,
      itemBuilder: (context, index) {
        final plant = plants[index];
        return GestureDetector(
          onTap: () {
            plantProvider.clearCurrentPlant();
            plantProvider.currentPlant = plant;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ResultsScreen(),
              ),
            );
          },
          child: PlantCard(plant: plant),
        );
      },
    );
  }

  List<dynamic> _getFilteredPlants(PlantProvider plantProvider) {
    switch (_selectedFilter) {
      case 'healthy':
        return plantProvider.plantHistory
            .where((plant) => plant.diseases.isEmpty)
            .toList();
      case 'needs_care':
        return plantProvider.getPlantsWithDiseases();
      case 'recent':
        return plantProvider.getRecentPlants();
      default:
        return plantProvider.plantHistory;
    }
  }

  String _getFilterLabel(String filter) {
    switch (filter) {
      case 'all':
        return 'All Plants';
      case 'healthy':
        return 'Healthy';
      case 'needs_care':
        return 'Needs Care';
      case 'recent':
        return 'Recent';
      default:
        return 'All Plants';
    }
  }
}