import 'package:flutter/material.dart';

void main() {
  runApp(MyCoachApp());
}

class MyCoachApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyCoach MVP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8B5CF6)),
        useMaterial3: true,
      ),
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.fitness_center,
                size: 120,
                color: Color(0xFF8B5CF6),
              ),
              const SizedBox(height: 32),
              const Text(
                'MyCoach MVP',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Choisissez votre profil',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 48),
              _buildProfileButton(
                context,
                'Coach',
                Icons.person_4,
                const Color(0xFF8B5CF6),
                () => _navigateTo(context, 'Coach'),
              ),
              const SizedBox(height: 16),
              _buildProfileButton(
                context,
                'Client',
                Icons.person,
                const Color(0xFF06B6D4),
                () => _navigateTo(context, 'Client'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: color, size: 32),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios, color: color, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, String userType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardScreen(userType: userType),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final String userType;

  const DashboardScreen({Key? key, required this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCoach = userType == 'Coach';
    final primaryColor = isCoach ? const Color(0xFF8B5CF6) : const Color(0xFF06B6D4);
    final backgroundColor = isCoach ? const Color(0xFF0F0F23) : const Color(0xFFF8FAFC);
    final textColor = isCoach ? Colors.white : const Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'Dashboard $userType',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenue, $userType !',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 32),
              _buildStatsCard(primaryColor, textColor, backgroundColor),
              const SizedBox(height: 24),
              Text(
                isCoach ? 'Séances du jour' : 'Mes programmes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return _buildListItem(index, primaryColor, textColor, backgroundColor, isCoach);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(Color primaryColor, Color textColor, Color backgroundColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor.withOpacity(0.2), primaryColor.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '24',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              Text(
                userType == 'Coach' ? 'Clients actifs' : 'Séances complétées',
                style: TextStyle(color: textColor.withOpacity(0.7)),
              ),
            ],
          ),
          Icon(
            userType == 'Coach' ? Icons.people : Icons.emoji_events,
            color: primaryColor,
            size: 48,
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(int index, Color primaryColor, Color textColor, Color backgroundColor, bool isCoach) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor == const Color(0xFF0F0F23) 
            ? const Color(0xFF1E1E3F) 
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: primaryColor.withOpacity(0.2),
            child: Icon(
              isCoach ? Icons.person : Icons.fitness_center,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCoach ? 'Séance avec Client ${index + 1}' : 'Programme ${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Text(
                  isCoach ? '15h30 - Musculation' : '3x par semaine - Cardio',
                  style: TextStyle(
                    color: textColor.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: primaryColor,
            size: 16,
          ),
        ],
      ),
    );
  }
}