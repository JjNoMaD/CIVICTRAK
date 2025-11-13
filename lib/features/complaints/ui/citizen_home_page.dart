import 'package:flutter/material.dart';

class CitizenHomePage extends StatelessWidget {
  const CitizenHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citizen Dashboard'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home_work_outlined, size: 100, color: Colors.deepPurple),
            const SizedBox(height: 30),
            const Text(
              'Welcome to CivicTrack!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            const Text(
              'You can view or submit complaints below:',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 40),

            // 🔹 Button to submit a normal complaint
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/submit'),
              icon: const Icon(Icons.report),
              label: const Text('Submit a Complaint'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Button to submit an anonymous complaint (optional)
            OutlinedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/submit/anonymous'),
              icon: const Icon(Icons.visibility_off),
              label: const Text('Submit Anonymous Complaint'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.deepPurple,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Button to view submitted complaints
            OutlinedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/citizen/list'),
              icon: const Icon(Icons.list),
              label: const Text('View Complaints'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.deepPurple,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
