import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/shimmer_loading.dart';

class CoachDashboardPage extends StatefulWidget {
  const CoachDashboardPage({super.key});

  @override
  State<CoachDashboardPage> createState() => _CoachDashboardPageState();
}

class _CoachDashboardPageState extends State<CoachDashboardPage> {
  bool _isLoading = false;
  final String _coachName = 'Sarah'; // TODO: Get from user state

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: Load dashboard data from API
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(now);

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Container(
                color: AppColors.backgroundLight,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.base,
                      AppDimensions.sm,
                      AppDimensions.base,
                      AppDimensions.base,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${AppStrings.hello}, $_coachName 👋',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.xs),
                              Text(
                                formattedDate,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.primaryContainer,
                          child: Text(
                            'SM', // TODO: Get initials from user
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Stats Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.base),
                child: _isLoading
                    ? const _StatsShimmer()
                    : const _StatsSection(),
              ),
            ),

            // Today's Sessions
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.base),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.todaySessions,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Navigate to sessions list
                          },
                          child: Text(
                            AppStrings.seeAll,
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.md),
                    SizedBox(
                      height: 120,
                      child: _isLoading
                          ? const _SessionsShimmer()
                          : const _SessionsList(),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppDimensions.xl),
            ),

            // Recent Clients
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.base),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.recentClients,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Navigate to clients list
                          },
                          child: Text(
                            AppStrings.seeAll,
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.md),
                  ],
                ),
              ),
            ),

            // Recent Clients List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.base),
              sliver: _isLoading
                  ? const SliverToBoxAdapter(child: _ClientsShimmer())
                  : const _ClientsList(),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 100), // Navigation bar clearance
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        const _StatCard(
          icon: Icons.people,
          iconColor: AppColors.primary,
          value: '12',
          label: AppStrings.clients,
        ),
        const SizedBox(width: AppDimensions.md),
        const _StatCard(
          icon: Icons.fitness_center,
          iconColor: AppColors.success,
          value: '8',
          label: AppStrings.programs,
        ),
        const SizedBox(width: AppDimensions.md),
        const _StatCard(
          icon: Icons.chat_bubble,
          iconColor: AppColors.warning,
          value: '3',
          label: AppStrings.messages,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.base),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: AppColors.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: AppDimensions.iconBase,
              color: iconColor,
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionsList extends StatelessWidget {
  const _SessionsList();

  @override
  Widget build(BuildContext context) {
    // Mock data
    final sessions = [
      _SessionData(
        time: '09:00',
        clientName: 'Marie Dupont',
        program: 'Force & Cardio',
        status: _SessionStatus.upcoming,
      ),
      _SessionData(
        time: '11:30',
        clientName: 'Paul Martin',
        program: 'Musculation',
        status: _SessionStatus.inProgress,
      ),
      _SessionData(
        time: '14:00',
        clientName: 'Julie Leclerc',
        program: 'Fitness',
        status: _SessionStatus.completed,
      ),
    ];

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: sessions.length,
      separatorBuilder: (context, index) => const SizedBox(width: AppDimensions.md),
      itemBuilder: (context, index) {
        final session = sessions[index];
        return _SessionCard(session: session);
      },
    );
  }
}

class _SessionCard extends StatelessWidget {
  final _SessionData session;

  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (session.status) {
      _SessionStatus.upcoming => AppColors.primary,
      _SessionStatus.inProgress => AppColors.warning,
      _SessionStatus.completed => AppColors.success,
    };

    final statusText = switch (session.status) {
      _SessionStatus.upcoming => 'À venir',
      _SessionStatus.inProgress => 'En cours',
      _SessionStatus.completed => 'Terminé',
    };

    return Container(
      width: 260,
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: double.infinity,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  session.clientName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  session.program,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.sm,
                    vertical: AppDimensions.xs,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                  child: Text(
                    statusText,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClientsList extends StatelessWidget {
  const _ClientsList();

  @override
  Widget build(BuildContext context) {
    // Mock data
    final clients = [
      _ClientData(
        name: 'Marie Dupont',
        lastContact: 'il y a 2h',
        initials: 'MD',
      ),
      _ClientData(
        name: 'Paul Martin',
        lastContact: 'hier',
        initials: 'PM',
      ),
      _ClientData(
        name: 'Julie Leclerc',
        lastContact: 'il y a 3j',
        initials: 'JL',
      ),
    ];

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final client = clients[index];
          return Container(
            margin: const EdgeInsets.only(bottom: AppDimensions.sm),
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              border: Border.all(color: AppColors.outline),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primaryContainer,
                  child: Text(
                    client.initials,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client.name,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Dernier contact: ${client.lastContact}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: AppDimensions.iconBase,
                  color: AppColors.textDisabled,
                ),
              ],
            ),
          );
        },
        childCount: clients.length,
      ),
    );
  }
}

// Shimmer loading widgets
class _StatsShimmer extends StatelessWidget {
  const _StatsShimmer();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: ShimmerLoading(height: 80)),
        SizedBox(width: AppDimensions.md),
        Expanded(child: ShimmerLoading(height: 80)),
        SizedBox(width: AppDimensions.md),
        Expanded(child: ShimmerLoading(height: 80)),
      ],
    );
  }
}

class _SessionsShimmer extends StatelessWidget {
  const _SessionsShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      separatorBuilder: (context, index) => const SizedBox(width: AppDimensions.md),
      itemBuilder: (context, index) => const ShimmerLoading(width: 260, height: 120),
    );
  }
}

class _ClientsShimmer extends StatelessWidget {
  const _ClientsShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (index) => 
        Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.sm),
          child: const ShimmerLoading(height: 60),
        ),
      ),
    );
  }
}

// Data classes
class _SessionData {
  final String time;
  final String clientName;
  final String program;
  final _SessionStatus status;

  _SessionData({
    required this.time,
    required this.clientName,
    required this.program,
    required this.status,
  });
}

enum _SessionStatus {
  upcoming,
  inProgress,
  completed,
}

class _ClientData {
  final String name;
  final String lastContact;
  final String initials;

  _ClientData({
    required this.name,
    required this.lastContact,
    required this.initials,
  });
}