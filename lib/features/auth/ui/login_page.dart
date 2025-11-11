import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String selectedRole = 'citizen';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() {
    // Mock login flow for demonstration
    if (selectedRole == 'citizen') {
      Navigator.pushReplacementNamed(context, '/home/citizen');
    } else if (selectedRole == 'staff') {
      Navigator.pushReplacementNamed(context, '/home/staff');
    } else if (selectedRole == 'admin') {
      Navigator.pushReplacementNamed(context, '/home/admin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_circle, size: 100, color: Colors.deepPurple),
              const SizedBox(height: 20),
              const Text(
                'CivicTrack Login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),

              // Role selector buttons
              ToggleButtons(
                borderRadius: BorderRadius.circular(30),
                isSelected: [
                  selectedRole == 'citizen',
                  selectedRole == 'staff',
                  selectedRole == 'admin',
                ],
                onPressed: (index) {
                  setState(() {
                    if (index == 0) selectedRole = 'citizen';
                    if (index == 1) selectedRole = 'staff';
                    if (index == 2) selectedRole = 'admin';
                  });
                },
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Text('Citizen'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Text('Staff'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Text('Admin'),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Email/Username input
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email/Username',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password input
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 🔹 NEW BUTTON: Submit Anonymous Complaint
              TextButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, '/submit/anonymous'),
                icon: const Icon(Icons.visibility_off, color: Colors.deepPurple),
                label: const Text(
                  'Submit Anonymous Complaint',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Footer text
              const Text(
                'Track and report civic issues easily!',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
