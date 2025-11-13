// lib/config/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/ui/login_page.dart';
import '../features/complaints/ui/submit_complaint_page.dart';
import '../features/complaints/ui/complaint_list_page.dart';
import '../features/complaints/ui/complaint_detail_page.dart';
import '../features/complaints/ui/citizen_complaint_detail_page.dart';
import '../features/complaints/ui/citizen_complaint_list_page.dart';
import '../features/complaints/ui/upload_proof_page.dart';
import '../features/admin/ui/admin_dashboard_page.dart';
import 'auth_guard.dart';
import '../features/complaints/data/complaint_model.dart';

/// Build and return the GoRouter instance
GoRouter buildRouter() => GoRouter(
  initialLocation: '/login',
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Page not found!'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/login'),
            child: const Text('Go to Login'),
          ),
        ],
      ),
    ),
  ),
  routes: [
    /// ==================== AUTH ROUTES ====================
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),

    /// ==================== CITIZEN ROUTES ====================
    GoRoute(
      path: '/citizen/home',
      name: 'citizen_home',
      builder: (context, state) => _buildCitizenHomePage(),
      redirect: authGuardCitizen,
    ),
    GoRoute(
      path: '/citizen/submit',
      name: 'citizen_submit',
      builder: (context, state) => const SubmitComplaintPage(),
      redirect: authGuardCitizen,
    ),
    GoRoute(
      path: '/citizen/list',
      name: 'citizen_list',
      builder: (context, state) => const CitizenComplaintListPage(),
      redirect: authGuardCitizen,
    ),
    GoRoute(
      path: '/citizen/detail/:id',
      name: 'citizen_detail',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'unknown';

        // Create a sample complaint item for detail view
        final item = ComplaintItem(
          id: id,
          title: "Your Complaint",
          description: "This is your complaint details.",
          category: "Road / Pothole",
          address: "MG Road, Kochi",
          status: ComplaintStatus.inProgress,
          reportedAt: DateTime.now(),
        );

        return CitizenComplaintDetailPage(item: item);
      },
      redirect: authGuardCitizen,
    ),

    /// ==================== STAFF ROUTES ====================
    GoRoute(
      path: '/staff/home',
      name: 'staff_home',
      builder: (context, state) => _buildStaffHomePage(),
      redirect: authGuardStaff,
    ),
    GoRoute(
      path: '/staff/list',
      name: 'staff_list',
      builder: (context, state) => const ComplaintListPage(),
      redirect: authGuardStaff,
    ),
    GoRoute(
      path: '/staff/detail/:id',
      name: 'staff_detail',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'unknown';
        return const ComplaintListPage();
      },
      redirect: authGuardStaff,
    ),
    GoRoute(
      path: '/staff/upload/:id',
      name: 'staff_upload',
      builder: (context, state) =>
          UploadProofPage(id: state.pathParameters['id']!),
      redirect: authGuardStaff,
    ),

    /// ==================== ADMIN ROUTES ====================
    GoRoute(
      path: '/admin/home',
      name: 'admin_home',
      builder: (context, state) => const AdminDashboardPage(),
      redirect: authGuardAdmin,
    ),
    GoRoute(
      path: '/admin/complaints',
      name: 'admin_complaints',
      builder: (context, state) => const ComplaintListPage(),
      redirect: authGuardAdmin,
    ),
    GoRoute(
      path: '/admin/detail/:id',
      name: 'admin_detail',
      builder: (context, state) {
        return const ComplaintListPage();
      },
      redirect: authGuardAdmin,
    ),

    /// ==================== GENERIC ROUTES ====================
    GoRoute(
      path: '/list',
      name: 'complaint_list',
      builder: (context, state) => const ComplaintListPage(),
      redirect: authGuardAny,
    ),
    GoRoute(
      path: '/detail/:id',
      name: 'complaint_detail',
      builder: (context, state) {
        return const ComplaintListPage();
      },
      redirect: authGuardAny,
    ),
  ],
);

/// Citizen Home Page - shows citizen dashboard
Widget _buildCitizenHomePage() {
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
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildActionCard(
                  title: 'Submit Complaint',
                  icon: Icons.add_circle,
                  color: Colors.blue,
                  onTap: () {},
                ),
                _buildActionCard(
                  title: 'My Complaints',
                  icon: Icons.list,
                  color: Colors.green,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// Staff Home Page - shows staff dashboard
Widget _buildStaffHomePage() {
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
                  title: 'Assigned Complaints',
                  icon: Icons.assignment,
                  color: Colors.orange,
                  onTap: () {},
                ),
                _buildActionCard(
                  title: 'All Complaints',
                  icon: Icons.list,
                  color: Colors.purple,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// Helper widget to build action cards
Widget _buildActionCard({
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