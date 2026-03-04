import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';

class ClientsListPage extends StatefulWidget {
  const ClientsListPage({super.key});

  @override
  State<ClientsListPage> createState() => _ClientsListPageState();
}

class _ClientsListPageState extends State<ClientsListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Tous';
  final bool _isLoading = false;

  final List<String> _filters = ['Tous', 'Actifs', 'Inactifs', 'Récents'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              AppStrings.clients,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.sm,
                vertical: AppDimensions.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: Text(
                '12/15',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Show filter bottom sheet
            },
            icon: const Icon(
              Icons.filter_list,
              size: AppDimensions.iconMd,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(AppDimensions.base),
            color: AppColors.backgroundLight,
            child: Container(
              height: AppDimensions.inputHeight,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: AppStrings.searchClients,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: AppDimensions.iconBase,
                    color: AppColors.textDisabled,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.base,
                    vertical: AppDimensions.md,
                  ),
                ),
              ),
            ),
          ),

          // Filter Chips
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.base),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (context, index) => SizedBox(width: AppDimensions.sm),
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
                  shape: StadiumBorder(),
                );
              },
            ),
          ),

          // Clients List
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _buildClientsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Show add client bottom sheet
        },
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        icon: Icon(Icons.person_add),
        label: Text(AppStrings.add),
      ),
    );
  }

  Widget _buildClientsList() {
    // Mock clients data
    final clients = [
      const _ClientData(
        name: 'Marie Dupont',
        email: 'marie.dupont@email.com',
        program: 'Force & Cardio',
        lastSession: 'hier',
        status: 'Actif',
        initials: 'MD',
      ),
      const _ClientData(
        name: 'Paul Martin',
        email: 'paul.martin@email.com',
        program: 'Musculation',
        lastSession: 'il y a 2 jours',
        status: 'Actif',
        initials: 'PM',
      ),
      const _ClientData(
        name: 'Julie Leclerc',
        email: 'julie.leclerc@email.com',
        program: 'Fitness',
        lastSession: 'il y a 1 semaine',
        status: 'Inactif',
        initials: 'JL',
      ),
    ];

    if (clients.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.base),
      itemCount: clients.length,
      itemBuilder: (context, index) {
        final client = clients[index];
        return _ClientCard(
          client: client,
          onTap: () {
            // TODO: Navigate to client detail
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people_outline,
                size: AppDimensions.iconXxl,
                color: AppColors.outline,
              ),
            ),
            SizedBox(height: AppDimensions.xl),
            Text(
              AppStrings.noClients,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppDimensions.sm),
            Text(
              AppStrings.noClientsDescription,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimensions.xl),
            FilledButton.icon(
              onPressed: () {
                // TODO: Show add client dialog
              },
              icon: Icon(Icons.person_add),
              label: Text(AppStrings.addClient),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClientCard extends StatelessWidget {
  final _ClientData client;
  final VoidCallback onTap;

  _ClientCard({
    super.key,
    required this.client,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = client.status == 'Actif';
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.base),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primaryContainer,
                  child: Text(
                    client.initials,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              client.name,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                                  : AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                            ),
                            child: Text(
                              client.status,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: isActive 
                                    ? AppColors.success 
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimensions.xs),
                      Text(
                        'Programme: ${client.program}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: AppColors.textDisabled,
                          ),
                          SizedBox(width: AppDimensions.xs),
                          Text(
                            'Dernière séance: ${client.lastSession}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textDisabled,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: AppDimensions.iconBase,
                  color: AppColors.outline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ClientData {
  final String name;
  final String email;
  final String program;
  final String lastSession;
  final String status;
  final String initials;

  const _ClientData({
    required this.name,
    required this.email,
    required this.program,
    required this.lastSession,
    required this.status,
    required this.initials,
  });
}