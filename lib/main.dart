// main.dart

import 'package:flutter/material.dart';
import 'core/session.dart';

// --- ADD THESE DATA MODEL IMPORTS (Primary Sources) ---

import 'features/auth/ui/login_page.dart';
import 'features/complaints/ui/submit_complaint_page.dart';// 👈 HIDE from here
import 'features/complaints/ui/complaint_list_page.dart' hide ComplaintStatus;
 // 👈 HIDE from here
import 'features/admin/ui/admin_dashboard_page.dart' hide ComplaintStatus;
void main() => runApp(const CivicTrackApp());

class CivicTrackApp extends StatelessWidget {
  const CivicTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'civicTrack',
  theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),

  // 👇 start here; SplashGate will push to the right home
  home: const _SplashGate(),

  routes: {
  '/login': (_) => const LoginPage(),
  '/home/citizen': (_) => const CitizenHomePage(),
  '/home/staff': (_) => const StaffHomePage(),
  '/home/admin': (_) => const AdminDashboardPage(),
  '/submit': (_) => const SubmitComplaintPage(),
  // NEW: anonymous shortcut
  '/submit/anonymous': (_) => const SubmitComplaintPage(
        anonymousDefault: true,
        lockAnonymous: true,
      ),
  '/list': (_) => const ComplaintListPage(),
 

},

);



  }
}

/// Decides where to go based on saved role
class _SplashGate extends StatelessWidget {
  const _SplashGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserRole?>(
      future: Session.getRole(),
      builder: (context, snapshot) {
        // 1) Show spinner only while the future is still running
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2) Future is done. Read role (can be null on first launch)
        final role = snapshot.data;

        // 3) Route based on role; null -> Login
        if (role == UserRole.staff) {
          return const StaffHomePage();
        } else if (role == UserRole.admin) {
          return const AdminDashboardPage();
        } else if (role == UserRole.citizen) {
          return const CitizenHomePage();
        } else {
          // No role saved yet → go to Login
          return const LoginPage();
        }
      },
    );
  }
}

/// ---------- Citizen Home ----------
class CitizenHomePage extends StatelessWidget {
  const CitizenHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CivicTrack • Citizen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async { await Session.logout(); if (context.mounted) Navigator.pushReplacementNamed(context, '/login'); },
          )
        ],
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.location_city, size: 96),
          const SizedBox(height: 16),
          const Text('Welcome, Citizen', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/submit'),
            icon: const Icon(Icons.report),
            label: const Text('Submit a Complaint'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/list'),
            icon: const Icon(Icons.list),
            label: const Text('View My Complaints'),
          ),
        ]),
      ),
    );
  }
}

/// ---------- Staff Home ----------
class StaffHomePage extends StatelessWidget {
  const StaffHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CivicTrack • Staff'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async { await Session.logout(); if (context.mounted) Navigator.pushReplacementNamed(context, '/login'); },
          )
        ],
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.engineering, size: 96),
          const SizedBox(height: 16),
          const Text('Welcome, Municipal Staff', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/list'), // show assigned list later
            icon: const Icon(Icons.assignment),
            label: const Text('View Assigned Complaints'),
          ),
        ]),
      ),
    );
  }
}
