// lib/features/admin/ui/admin_reports_page.dart
import 'package:flutter/material.dart';

class AdminReportsPage extends StatelessWidget {
  const AdminReportsPage({super.key});

  // Dummy analytics
  static const totalsByCategory = {
    'Road': 10,
    'Water': 6,
    'Lighting': 8,
    'Sanitation': 12,
    'Other': 6,
  };

  static const totalsByStatus = {
    'Assigned': 18,
    'In Progress': 12,
    'Resolved': 8,
    'Escalated': 4,
  };

  @override
  Widget build(BuildContext context) {
    final maxCat = totalsByCategory.values.fold<int>(0, (p, n) => n > p ? n : p);
    final maxStatus = totalsByStatus.values.fold<int>(0, (p, n) => n > p ? n : p);

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Reports & Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Complaints by Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...totalsByCategory.entries.map((e) => _horizontalBar(e.key, e.value, maxCat)),
          const SizedBox(height: 18),
          const Divider(),
          const SizedBox(height: 12),
          const Text('Complaints by Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...totalsByStatus.entries.map((e) => _horizontalBar(e.key, e.value, maxStatus, showCount: true)),
          const SizedBox(height: 24),
          Center(
            child: FilledButton(
              onPressed: () {
                // In real app: refresh from API
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Refreshed (dummy)')));
              },
              child: const Text('Refresh Data'),
            ),
          ),
          const SizedBox(height: 30),
          const Text('Notes', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('This page displays sample analytics using dummy data. Connect your backend to fetch real metrics.'),
        ]),
      ),
    );
  }

  Widget _horizontalBar(String label, int value, int max, {bool showCount = false}) {
    final pct = max == 0 ? 0.0 : value / max;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        SizedBox(width: 120, child: Text(label)),
        const SizedBox(width: 12),
        Expanded(
          child: Stack(children: [
            Container(height: 20, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(6))),
            FractionallySizedBox(
              widthFactor: pct,
              child: Container(height: 20, decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(6))),
            ),
          ]),
        ),
        if (showCount) ...[
          const SizedBox(width: 10),
          Text(value.toString()),
        ],
      ]),
    );
  }
}
