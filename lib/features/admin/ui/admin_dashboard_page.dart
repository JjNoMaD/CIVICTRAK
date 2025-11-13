// lib/features/admin/ui/admin_dashboard_page.dart
import 'package:flutter/material.dart';

enum ComplaintStatus { unassigned, assigned, inProgress, resolved, escalated }

class _AdminComplaint {
  final String id;
  final String title;
  final String address;
  ComplaintStatus status;
  final DateTime reportedAt;
  final String category;
  final String description;
  String? assignee; // who it's assigned to (nullable)

  _AdminComplaint({
    required this.id,
    required this.title,
    required this.address,
    required this.status,
    required this.reportedAt,
    required this.category,
    required this.description,
    this.assignee,
  });

  _AdminComplaint copyWith({
    ComplaintStatus? status,
    String? assignee,
    String? description,
    String? category,
    String? address,
  }) {
    return _AdminComplaint(
      id: id,
      title: title,
      address: address ?? this.address,
      status: status ?? this.status,
      reportedAt: reportedAt,
      category: category ?? this.category,
      description: description ?? this.description,
      assignee: assignee ?? this.assignee,
    );
  }
}

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  // Dummy complaints (local)
  final List<_AdminComplaint> _allComplaints = [
    _AdminComplaint(
      id: 'W1699800001',
      title: 'Pothole - MG Road',
      address: 'MG Road',
      status: ComplaintStatus.assigned,
      reportedAt: DateTime.now().subtract(const Duration(days: 2)),
      category: 'Road',
      description: 'Large pothole causing traffic hazard.',
      assignee: 'Ramesh',
    ),
    _AdminComplaint(
      id: 'W1699800002',
      title: 'Streetlight not working',
      address: '3rd Block',
      status: ComplaintStatus.inProgress,
      reportedAt: DateTime.now().subtract(const Duration(days: 1)),
      category: 'Lighting',
      description: 'One streetlight on 3rd block has been off for 3 days.',
      assignee: 'Anita',
    ),
    _AdminComplaint(
      id: 'W1699800003',
      title: 'Overflowing drain',
      address: 'Pine & 7th',
      status: ComplaintStatus.escalated,
      reportedAt: DateTime.now().subtract(const Duration(hours: 12)),
      category: 'Drainage',
      description: 'Sewage is overflowing at the corner drain.',
    ),
    _AdminComplaint(
      id: 'W1699800004',
      title: 'Garbage dump',
      address: 'Old Bus Stand',
      status: ComplaintStatus.resolved,
      reportedAt: DateTime.now().subtract(const Duration(days: 5)),
      category: 'Sanitation',
      description: 'Garbage dumping spot not cleaned.',
      assignee: 'Kumar',
    ),
    _AdminComplaint(
      id: 'W1699800005',
      title: 'New report (unassigned)',
      address: 'Sector 9',
      status: ComplaintStatus.unassigned,
      reportedAt: DateTime.now().subtract(const Duration(hours: 6)),
      category: 'Other',
      description: 'New report waiting to be assigned.',
    ),
  ];

  // Dummy staff list (replace with real staff later)
  final List<String> _staffList = ['Ramesh', 'Anita', 'Kumar', 'Meera', 'Suresh'];

  ComplaintStatus? _filter;

  List<_AdminComplaint> get _filtered {
    if (_filter == null) return _allComplaints;
    return _allComplaints.where((c) => c.status == _filter).toList();
  }

  int get _total => _allComplaints.length;
  int get _unassigned => _allComplaints.where((c) => c.status == ComplaintStatus.unassigned).length;
  int get _assigned => _allComplaints.where((c) => c.status == ComplaintStatus.assigned).length;
  int get _inProgress => _allComplaints.where((c) => c.status == ComplaintStatus.inProgress).length;
  int get _resolved => _allComplaints.where((c) => c.status == ComplaintStatus.resolved).length;
  int get _escalated => _allComplaints.where((c) => c.status == ComplaintStatus.escalated).length;

  Color _colorForStatus(ComplaintStatus s) {
    switch (s) {
      case ComplaintStatus.unassigned:
        return Colors.grey;
      case ComplaintStatus.assigned:
        return Colors.orange;
      case ComplaintStatus.inProgress:
        return Colors.blue;
      case ComplaintStatus.resolved:
        return Colors.green;
      case ComplaintStatus.escalated:
        return Colors.redAccent;
    }
  }

  String _labelForStatus(ComplaintStatus s) {
    switch (s) {
      case ComplaintStatus.unassigned:
        return 'Unassigned';
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

  void _setFilter(ComplaintStatus? f) => setState(() => _filter = f);
  void _clearFilter() => setState(() => _filter = null);

  // Show quick detail + actions. If unassigned, show Assign action.
  void _showComplaintDetail(_AdminComplaint c) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(c.title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${c.id}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.black54),
                  const SizedBox(width: 6),
                  Text(c.address, style: const TextStyle(fontWeight: FontWeight.w600)),
                ]),
                const SizedBox(height: 8),
                Text('Category: ${c.category}', style: const TextStyle(color: Colors.black87)),
                const SizedBox(height: 8),
                Text('Status: ${_labelForStatus(c.status)}',
                    style: TextStyle(color: _colorForStatus(c.status))),
                if (c.assignee != null) ...[
                  const SizedBox(height: 8),
                  Text('Assigned to: ${c.assignee}', style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
                const SizedBox(height: 12),
                Text('Description:', style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(c.description),
                const SizedBox(height: 12),
                Text('Reported: ${c.reportedAt}'),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
            // Assignment action only shown if complaint is unassigned
            if (c.status == ComplaintStatus.unassigned)
              ElevatedButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text('Assign to staff'),
                onPressed: () {
                  Navigator.pop(context); // close details
                  _assignToStaffDialog(c);
                },
              ),
            PopupMenuButton<String>(
              onSelected: (choice) {
                Navigator.pop(context); // close details
                _handleAdminAction(choice, c);
              },
              itemBuilder: (ctx) {
                final items = <PopupMenuEntry<String>>[];
                // Always allow marking progress / resolve (admin testing)
                items.add(const PopupMenuItem(value: 'inprogress', child: Text('Mark In Progress')));
                items.add(const PopupMenuItem(value: 'resolve', child: Text('Mark Resolved')));
                items.add(const PopupMenuItem(value: 'escalate', child: Text('Escalate')));
                return items;
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.more_horiz),
                  label: const Text('Actions'),
                  onPressed: null,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Dialog to choose staff and assign
  Future<void> _assignToStaffDialog(_AdminComplaint c) async {
    String? selected = _staffList.isNotEmpty ? _staffList.first : null;

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Assign complaint'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_staffList.isEmpty)
                const Text('No staff available (dummy list is empty).')
              else
                DropdownButtonFormField<String>(
                  initialValue: selected,
                  items: _staffList.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) => selected = v,
                  decoration: const InputDecoration(labelText: 'Select staff'),
                ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: selected == null
                  ? null
                  : () {
                      Navigator.pop(ctx);
                      // update local list
                      setState(() {
                        final idx = _allComplaints.indexWhere((it) => it.id == c.id);
                        if (idx != -1) {
                          _allComplaints[idx] = _allComplaints[idx].copyWith(
                            status: ComplaintStatus.assigned,
                            assignee: selected,
                          );
                        }
                      });
                    },
              child: const Text('Assign'),
            ),
          ],
        );
      },
    );
  }

  void _handleAdminAction(String choice, _AdminComplaint c) {
    setState(() {
      final idx = _allComplaints.indexWhere((e) => e.id == c.id);
      if (idx == -1) return;
      switch (choice) {
        case 'inprogress':
          _allComplaints[idx] = _allComplaints[idx].copyWith(status: ComplaintStatus.inProgress);
          break;
        case 'resolve':
          _allComplaints[idx] = _allComplaints[idx].copyWith(status: ComplaintStatus.resolved);
          break;
        case 'escalate':
          _allComplaints[idx] = _allComplaints[idx].copyWith(status: ComplaintStatus.escalated);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('CivicTrack • Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 600));
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text('Welcome, Administrator',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                icon: const Icon(Icons.inventory_2),
                label: const Text('View Unassigned'),
                onPressed: () => _setFilter(ComplaintStatus.unassigned),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.bar_chart),
                label: const Text('View Dashboard'),
                onPressed: () => _clearFilter(),
              ),
            ]),
            const SizedBox(height: 18),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              children: [
                _statTile('Total', _total, null, onTap: () => _clearFilter()),
                _statTile('Unassigned', _unassigned, ComplaintStatus.unassigned,
                    onTap: () => _setFilter(ComplaintStatus.unassigned)),
                _statTile('Assigned', _assigned, ComplaintStatus.assigned,
                    onTap: () => _setFilter(ComplaintStatus.assigned)),
                _statTile('In Progress', _inProgress, ComplaintStatus.inProgress,
                    onTap: () => _setFilter(ComplaintStatus.inProgress)),
                _statTile('Resolved', _resolved, ComplaintStatus.resolved,
                    onTap: () => _setFilter(ComplaintStatus.resolved)),
                _statTile('Escalated', _escalated, ComplaintStatus.escalated,
                    onTap: () => _setFilter(ComplaintStatus.escalated)),
              ],
            ),
            const SizedBox(height: 18),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(_filter == null ? 'All complaints' : 'Showing: ${_labelForStatus(_filter!)}',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              if (_filter != null)
                TextButton(onPressed: _clearFilter, child: const Text('Show all')),
            ]),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final c = _filtered[i];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    leading: CircleAvatar(
                      backgroundColor: _colorForStatus(c.status).withOpacity(0.15),
                      child: Icon(_iconForCategory(c.category), color: _colorForStatus(c.status)),
                    ),
                    title: Text(c.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const SizedBox(height: 6),
                      Text(c.address, style: const TextStyle(fontSize: 13)),
                      const SizedBox(height: 6),
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _colorForStatus(c.status).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(_labelForStatus(c.status),
                              style: TextStyle(color: _colorForStatus(c.status), fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 10),
                        Text(c.id, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                        if (c.assignee != null) ...[
                          const SizedBox(width: 12),
                          Chip(label: Text(c.assignee!)),
                        ],
                      ]),
                    ]),
                    trailing: IconButton(icon: const Icon(Icons.arrow_forward_ios), onPressed: () => _showComplaintDetail(c)),
                    onTap: () => _showComplaintDetail(c),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }

  Widget _statTile(String label, int value, ComplaintStatus? status, {VoidCallback? onTap}) {
    final selected = _filter == status || (_filter == null && status == null && label == 'Total' && _filter == null);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? Colors.deepPurple.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? Colors.deepPurple.shade100 : Colors.transparent),
        ),
        child: Row(children: [
          CircleAvatar(radius: 20, backgroundColor: Colors.deepPurple.shade100, child: Text(value.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: selected ? Colors.deepPurple : Colors.black87))),
        ]),
      ),
    );
  }

  IconData _iconForCategory(String category) {
  final s = category.toLowerCase();
  if (s.contains('light')) return Icons.lightbulb;
  // use a stable icon instead of Icons.road
  if (s.contains('road') || s.contains('pothole')) return Icons.construction;
  if (s.contains('drain') || s.contains('sewage')) return Icons.water;
  if (s.contains('garbage') || s.contains('dump')) return Icons.delete;
  return Icons.report_problem;
}

}
