import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../../../../shared/widgets/glass_container.dart';

class ClientDashboardPage extends StatefulWidget {
  const ClientDashboardPage({super.key});

  @override
  State<ClientDashboardPage> createState() => _ClientDashboardPageState();
}

class _ClientDashboardPageState extends State<ClientDashboardPage> {
  bool _isLoading = false;
  final String _clientName = 'Marie'; // TODO: Get from user state

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
      backgroundColor: AppColors.clientBackground,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.clientSecondary,
        child: CustomScrollView(
          slivers: [
            // Header with glass effect
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.clientPrimary,
                      AppColors.clientPrimary.withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.base,
                      AppDimensions.sm,
                      AppDimensions.base,
                      AppDimensions.xl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${AppStrings.hello}, $_clientName 👋',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.clientOnPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: AppDimensions.xs),
                                  Text(
                                    formattedDate,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.clientOnPrimary.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: AppColors.clientSecondary.withOpacity(0.2),
                              child: Text(
                                'ML', // TODO: Get initials from user
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: AppColors.clientSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: AppDimensions.xl),
                        
                        // Quick Actions
                        _isLoading 
                            ? const _QuickActionsShimmer()
                            : const _QuickActions(),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.base),
                child: Column(
                  children: [
                    // My Programs
                    _SectionHeader(
                      title: 'Mes Programmes',
                      onSeeAll: () {
                        // TODO: Navigate to programs
                      },
                    ),
                    const SizedBox(height: AppDimensions.md),
                    SizedBox(
                      height: 160,
                      child: _isLoading
                          ? const _ProgramsShimmer()
                          : const _ProgramsList(),
                    ),

                    const SizedBox(height: AppDimensions.xl),

                    // Upcoming Sessions
                    _SectionHeader(
                      title: 'Prochaines Séances',
                      onSeeAll: () {
                        // TODO: Navigate to sessions
                      },
                    ),
                    const SizedBox(height: AppDimensions.md),
                  ],
                ),
              ),
            ),

            // Upcoming Sessions List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.base),
              sliver: _isLoading
                  ? const SliverToBoxAdapter(child: _SessionsShimmer())
                  : const _SessionsList(),
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

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GlassButton(
            height: 56,
            onPressed: () {
              // TODO: Navigate to coach search
            },
            backgroundColor: AppColors.clientSecondary.withOpacity(0.2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.search,
                  size: AppDimensions.iconBase,
                  color: AppColors.clientSecondary,
                ),
                const SizedBox(width: AppDimensions.sm),
                Text(
                  'Trouver un coach',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.clientSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.md),
        GlassButton(
          width: 56,
          height: 56,
          onPressed: () {
            // TODO: Navigate to bookings
          },
          backgroundColor: AppColors.clientAccent.withOpacity(0.2),
          child: const Icon(
            Icons.calendar_today,
            size: AppDimensions.iconBase,
            color: AppColors.clientAccent,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const _SectionHeader({
    required this.title,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: Text(
              AppStrings.seeAll,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.clientSecondary,
              ),
            ),
          ),
      ],
    );
  }
}

class _ProgramsList extends StatelessWidget {
  const _ProgramsList();

  @override
  Widget build(BuildContext context) {
    // Mock data
    final programs = [
      _ProgramData(
        title: 'Force & Cardio',
        coach: 'Sarah Martin',
        progress: 0.65,
        nextSession: 'Demain 14:00',
        color: AppColors.clientSecondary,
      ),
      _ProgramData(
        title: 'Yoga Débutant',
        coach: 'Emma Durand',
        progress: 0.3,
        nextSession: 'Lundi 10:00',
        color: AppColors.success,
      ),
    ];

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: programs.length,
      separatorBuilder: (context, index) => const SizedBox(width: AppDimensions.md),
      itemBuilder: (context, index) {
        final program = programs[index];
        return _ProgramCard(program: program);
      },
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final _ProgramData program;

  const _ProgramCard({required this.program});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      width: 200,
      padding: const EdgeInsets.all(AppDimensions.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: program.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: Text(
                  program.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            'avec ${program.coach}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progression',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.xs),
              LinearProgressIndicator(
                value: program.progress,
                backgroundColor: AppColors.outline.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(program.color),
              ),
              const SizedBox(height: AppDimensions.sm),
              Text(
                program.nextSession,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: program.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
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
        time: '14:00',
        title: 'Force & Cardio',
        coach: 'Sarah Martin',
        date: 'Demain',
        status: _SessionStatus.confirmed,
      ),
      _SessionData(
        time: '10:00',
        title: 'Yoga Débutant',
        coach: 'Emma Durand',
        date: 'Lundi',
        status: _SessionStatus.pending,
      ),
    ];

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final session = sessions[index];
          return Container(
            margin: const EdgeInsets.only(bottom: AppDimensions.sm),
            child: GlassCard(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        session.time,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.clientSecondary,
                        ),
                      ),
                      Text(
                        session.date,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: AppDimensions.base),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.title,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'avec ${session.coach}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.sm,
                      vertical: AppDimensions.xs,
                    ),
                    decoration: BoxDecoration(
                      color: session.status == _SessionStatus.confirmed
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                    ),
                    child: Text(
                      session.status == _SessionStatus.confirmed
                          ? 'Confirmé'
                          : 'En attente',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: session.status == _SessionStatus.confirmed
                            ? AppColors.success
                            : AppColors.warning,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: 2,
      ),
    );
  }
}

// Shimmer loading widgets
class _QuickActionsShimmer extends StatelessWidget {
  const _QuickActionsShimmer();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: ShimmerLoading(height: 56)),
        SizedBox(width: AppDimensions.md),
        ShimmerLoading(width: 56, height: 56),
      ],
    );
  }
}

class _ProgramsShimmer extends StatelessWidget {
  const _ProgramsShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 2,
      separatorBuilder: (context, index) => const SizedBox(width: AppDimensions.md),
      itemBuilder: (context, index) => const ShimmerLoading(width: 200, height: 160),
    );
  }
}

class _SessionsShimmer extends StatelessWidget {
  const _SessionsShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(2, (index) => 
        Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.sm),
          child: const ShimmerLoading(height: 80),
        ),
      ),
    );
  }
}

// Data classes
class _ProgramData {
  final String title;
  final String coach;
  final double progress;
  final String nextSession;
  final Color color;

  _ProgramData({
    required this.title,
    required this.coach,
    required this.progress,
    required this.nextSession,
    required this.color,
  });
}

class _SessionData {
  final String time;
  final String title;
  final String coach;
  final String date;
  final _SessionStatus status;

  _SessionData({
    required this.time,
    required this.title,
    required this.coach,
    required this.date,
    required this.status,
  });
}

enum _SessionStatus {
  confirmed,
  pending,
}