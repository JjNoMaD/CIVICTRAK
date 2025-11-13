// lib/features/staff/ui/staff_home_page.dart
import 'package:flutter/material.dart';
import '../../complaints/ui/complaint_list_page.dart';
import '../../../core/session.dart'; // optional: if you have Session helpers

class StaffHomePage extends StatelessWidget {
  const StaffHomePage({super.key});

  Future<void> _logout(BuildContext context) async {
    // If you have a Session.logout() helper, call it here.
    // Wrap with try/catch in real app
    try {
      await Session.logout(); // comment this line out if you don't have Session
    } catch (_) {
      // ignore: avoid_print
      print('Session.logout not available or failed');
    } finally {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CivicTrack • Staff'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.engineering, size: 96, color: Colors.deepPurple),
              const SizedBox(height: 20),
              const Text(
                'Welcome, Municipal Staff',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Primary action: view assigned complaints
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.assignment),
                  label: const Text('View Assigned Complaints'),
                  onPressed: () {
                    // Use named route or MaterialPageRoute - both are fine.
                    // Named route (if you added '/staff/assigned' to routes):
                    if (Navigator.canPop(context)) {
                      // prefer named route (keeps navigation stack tidy)
                      Navigator.pushNamed(context, '/staff/assigned');
                    } else {
                      // fallback to direct push
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ComplaintListPage()),
                      );
                    }
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Optional: quick access to dashboard or other staff utilities
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.bar_chart),
                  label: const Text('View Dashboard'),
                  onPressed: () {
                    // Replace '/home/staff' or '/admin/reports' with your route.
                    Navigator.pushNamed(context, '/admin/reports');
                  },
                ),
              ),

              const SizedBox(height: 28),

              // Secondary actions row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                    onPressed: () {
                      // For now this just shows a snack — implement real refresh as needed
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Refreshing...')),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  TextButton.icon(
                    icon: const Icon(Icons.help_outline),
                    label: const Text('Help'),
                    onPressed: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'CivicTrack',
                        children: const [
                          Text('Municipal staff app — update complaint status, upload proof, and more.')
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
