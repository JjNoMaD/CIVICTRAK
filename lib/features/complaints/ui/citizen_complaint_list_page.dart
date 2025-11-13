// lib/features/complaints/ui/citizen_complaint_list_page.dart
import 'package:flutter/material.dart';
import '../data/complaint_model.dart';  // adjust path
import 'citizen_complaint_detail_page.dart';

class CitizenComplaintListPage extends StatelessWidget {
  const CitizenComplaintListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for the "citizen’s own complaints"
    final myComplaints = <ComplaintItem>[
      ComplaintItem(
        id: 'C1001',
        title: 'Garbage Dump near park',
        description: 'Large garbage pile near neighborhood park.',
        category: 'Garbage Dump',
        address: 'Karunagappally Park',
        status: ComplaintStatus.inProgress,
        reportedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      ComplaintItem(
        id: 'C1002',
        title: 'Water logging on Main Street',
        description: 'Heavy water stays after rains.',
        category: 'Stagnant Water',
        address: 'Main Street, Block A',
        status: ComplaintStatus.assigned,
        reportedAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      ),
      ComplaintItem(
        id: 'C1003',
        title: 'Open manhole – dangerous',
        description: 'Manhole cover missing near shop. Risk to children.',
        category: 'Open Manhole',
        address: 'Shop No. 4, Market Road',
        status: ComplaintStatus.resolved,
        reportedAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('My Complaints')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: myComplaints.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final c = myComplaints[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(c.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 6),
                Text(c.address, style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 6),
                Text('Status: ${_labelForStatus(c.status)}',
                     style: TextStyle(fontSize: 13, color: _colorForStatus(c.status))),
              ]),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CitizenComplaintDetailPage(item: c)),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _labelForStatus(ComplaintStatus s) {
    switch (s) {
      case ComplaintStatus.assigned:
        return 'Assigned';
      case ComplaintStatus.inProgress:
        return 'In Progress';
      case ComplaintStatus.resolved:
        return 'Resolved';
      case ComplaintStatus.escalated:
        return 'Escalated';
    }
  }

  Color _colorForStatus(ComplaintStatus s) {
    switch (s) {
      case ComplaintStatus.assigned:
        return Colors.orange;
      case ComplaintStatus.inProgress:
        return Colors.blue;
      case ComplaintStatus.resolved:
        return Colors.green;
      case ComplaintStatus.escalated:
        return Colors.red;
    }
  }
}
