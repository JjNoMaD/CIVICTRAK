// lib/features/complaints/ui/citizen_complaint_detail_page.dart
import 'package:flutter/material.dart';
import '../data/complaint_model.dart';

class CitizenComplaintDetailPage extends StatelessWidget {
  final ComplaintItem item;
  const CitizenComplaintDetailPage({super.key, required this.item});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ID: ${item.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(item.category, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),
          Text(item.description),
          const SizedBox(height: 12),
          Text('Address: ${item.address}', style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),
          Row(children: [
            const Icon(Icons.calendar_today, size: 16),
            const SizedBox(width: 8),
            Text('Reported: ${item.reportedAt.toLocal().toString().split('.').first}'),
          ]),
          const SizedBox(height: 12),
          Chip(
            label: Text(_labelForStatus(item.status)),
            backgroundColor: _colorForStatus(item.status).withOpacity(0.2),
          ),
          const SizedBox(height: 24),
          // optionally: if proofImagePath exists – show image. For demo you can skip.
        ]),
      ),
    );
  }
}
