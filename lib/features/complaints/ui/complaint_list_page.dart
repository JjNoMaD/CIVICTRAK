// lib/features/complaints/ui/complaint_list_page.dart
import 'package:flutter/material.dart';
import 'complaint_detail_page.dart';
import '../data/complaint_model.dart';
import 'dart:math';

class ComplaintListPage extends StatefulWidget {
  const ComplaintListPage({super.key});

  @override
  State<ComplaintListPage> createState() => _ComplaintListPageState();
}

class _ComplaintListPageState extends State<ComplaintListPage> {
  bool _loading = false;

  // dummy assigned complaints
  late List<ComplaintItem> _complaints;

  @override
  void initState() {
    super.initState();
    _complaints = List.generate(3, (i) {
      final id = 'W${Random().nextInt(999999).toString().padLeft(6, '0')}';
      final now = DateTime.now().subtract(Duration(days: i));
      return ComplaintItem(
        id: id,
        title: ['Pothole near MG Road', 'Streetlight not working', 'Overflowing drain'][i],
        description: ['Large pothole', 'Light bulb fused', 'Sewage overflow'][i],
        category: ['Road', 'Lighting', 'Drainage'][i],
        address: ['MG Road', '3rd Block', 'Pine & 7th'][i],
        status: i == 1 ? ComplaintStatus.inProgress : ComplaintStatus.assigned,
        reportedAt: now,
      );
    });
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() => _loading = false);
  }

  void _openDetail(int idx) async {
    final updated = await Navigator.push<ComplaintItem>(
      context,
      MaterialPageRoute(
        builder: (_) => ComplaintDetailPage(item: _complaints[idx]),
      ),
    );

    if (updated != null) {
      setState(() => _complaints[idx] = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complaint updated')),
      );
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

  IconData _iconForCategory(String c) {
    final s = c.toLowerCase();
    if (s.contains('light')) return Icons.lightbulb;
    if (s.contains('road') || s.contains('pothole')) return Icons.construction;
    if (s.contains('drain') || s.contains('sewage')) return Icons.water;
    return Icons.report_problem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigned Complaints'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: _complaints.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (ctx, i) {
                  final c = _complaints[i];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade50,
                        child: Icon(_iconForCategory(c.category), color: Colors.deepPurple),
                      ),
                      title: Text(c.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text(c.address, style: const TextStyle(fontSize: 13)),
                          const SizedBox(height: 6),
                          Text('Status: ${_labelForStatus(c.status)}',
                              style: TextStyle(fontSize: 13, color: _colorForStatus(c.status))),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () => _openDetail(i),
                      ),
                      onTap: () => _openDetail(i),
                    ),
                  );
                },
              ),
            ),
    );
  }
}