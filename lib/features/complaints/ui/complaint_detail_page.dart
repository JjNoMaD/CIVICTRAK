import 'package:flutter/material.dart';

class ComplaintDetailPage extends StatelessWidget {
  final String id;

  const ComplaintDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Complaint #$id')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Details of the selected complaint will appear here.'),
            SizedBox(height: 8),
            Text('You can load the complaint by this id from your repository.'),
          ],
        ),
      ),
    );
  }
}
