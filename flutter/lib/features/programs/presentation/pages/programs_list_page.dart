import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';

class ProgramsListPage extends StatefulWidget {
  const ProgramsListPage({super.key});

  @override
  State<ProgramsListPage> createState() => _ProgramsListPageState();
}

class _ProgramsListPageState extends State<ProgramsListPage> {
  String _selectedFilter = 'Tous';
  final List<String> _filters = ['Tous', 'Actifs', 'Brouillons', 'Archivés'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        title: Text(
          AppStrings.programs,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Show filter options
            },
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.base),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (context, index) => const SizedBox(width: AppDimensions.sm),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = filter == _selectedFilter;
                
                return FilterChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    }
                  },
                  backgroundColor: AppColors.surfaceVariant,
                  selectedColor: AppColors.primary,
                  labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected ? AppColors.onPrimary : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  shape: const StadiumBorder(),
                );
              },
            ),
          ),

          // Programs List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppDimensions.base),
              itemCount: 3, // Mock data count
              itemBuilder: (context, index) {
                return _ProgramCard(
                  name: 'Programme ${index + 1}',
                  duration: '8 semaines',
                  frequency: '4 séances/sem',
                  clients: 3,
                  exercises: 24,
                  progress: 0.65,
                  status: index == 0 ? 'Actif' : 'Brouillon',
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create program
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final String name;
  final String duration;
  final String frequency;
  final int clients;
  final int exercises;
  final double progress;
  final String status;

  const _ProgramCard({
    required this.name,
    required this.duration,
    required this.frequency,
    required this.clients,
    required this.exercises,
    required this.progress,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = status == 'Actif';
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.sm,
                      vertical: AppDimensions.xs,
                    ),
                    decoration: BoxDecoration(
                      color: isActive 
                          ? AppColors.secondaryContainer 
                          : AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                    ),
                    child: Text(
                      status,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isActive ? AppColors.success : AppColors.warning,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.xs),
              Text(
                '$duration • $frequency',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.sm),
              Row(
                children: [
                  Icon(
                    Icons.person_outlined,
                    size: 16,
                    color: AppColors.textDisabled,
                  ),
                  const SizedBox(width: AppDimensions.xs),
                  Text(
                    '$clients clients',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textDisabled,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.base),
                  Icon(
                    Icons.fitness_center,
                    size: 16,
                    color: AppColors.textDisabled,
                  ),
                  const SizedBox(width: AppDimensions.xs),
                  Text(
                    '$exercises exercices',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textDisabled,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.md),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.surfaceVariant,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                minHeight: 6,
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              const SizedBox(height: AppDimensions.xs),
              Text(
                'Semaine ${(progress * 8).round()}/8',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}