// main.dart

import 'package:flutter/material.dart';
import 'core/session.dart';

// --- Page Imports ---
import 'features/auth/ui/login_page.dart';
import 'features/complaints/ui/submit_complaint_page.dart';
import 'features/complaints/ui/complaint_list_page.dart';
import 'features/complaints/ui/citizen_complaint_list_page.dart';
import 'features/complaints/ui/citizen_complaint_detail_page.dart';
import 'features/admin/ui/admin_dashboard_page.dart';

void main() => runApp(const CivicTrackApp());

class CivicTrackApp extends StatelessWidget {
  const CivicTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'civicTrack',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      
      // 👇 start here; SplashGate will push to the right home
      home: const _SplashGate(),
      
      routes: {
        '/login': (_) => const LoginPage(),
        '/home/citizen': (_) => const CitizenHomePage(),
        '/home/staff': (_) => const StaffHomePage(),
        '/home/admin': (_) => const AdminDashboardPage(),
        '/submit': (_) => const SubmitComplaintPage(),
        '/citizen/list': (_) => const CitizenComplaintListPage(),
        '/staff/assigned': (_) => const ComplaintListPage(),
        '/submit/anonymous': (_) => const SubmitComplaintPage(
          anonymousDefault: true,
          lockAnonymous: true,
        ),
        '/list': (_) => const ComplaintListPage(),
      },
    );
  }
}

class _SplashGate extends StatelessWidget {
  const _SplashGate();

  @override
  Widget build(BuildContext context) {
    // TODO: Check SessionManager to determine which page to show
    // For now, return login page as default
    return const LoginPage();
  }
}

/// Citizen Home Page - shows citizen dashboard
class CitizenHomePage extends StatelessWidget {
  const CitizenHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citizen Dashboard'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome, Citizen!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              // Quick Action Cards
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildActionCard(
                    context,
                    title: 'Submit Complaint',
                    icon: Icons.add_circle,
                    color: Colors.blue,
                    onTap: () => Navigator.pushNamed(context, '/submit'),
                  ),
                  _buildActionCard(
                    context,
                    title: 'My Complaints',
                    icon: Icons.list,
                    color: Colors.green,
                    onTap: () => Navigator.pushNamed(context, '/citizen/list'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.7), color],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Staff Home Page - shows staff dashboard
class StaffHomePage extends StatelessWidget {
  const StaffHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Dashboard'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome, Staff!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              // Staff Action Cards
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildActionCard(
                    context,
                    title: 'Assigned Complaints',
                    icon: Icons.assignment,
                    color: Colors.orange,
                    onTap: () => Navigator.pushNamed(context, '/staff/assigned'),
                  ),
                  _buildActionCard(
                    context,
                    title: 'All Complaints',
                    icon: Icons.list,
                    color: Colors.purple,
                    onTap: () => Navigator.pushNamed(context, '/list'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.7), color],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}