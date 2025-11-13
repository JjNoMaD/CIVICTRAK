import 'package:flutter/material.dart';

// Private enum to manage the state of the form (Login or Register)
enum _FormType { login, register }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // State for role and form type
  String selectedRole = 'citizen';
  _FormType _formType = _FormType.login;

  // Controllers for input fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController mobileController = TextEditingController(); // New controller for mobile

  String get _buttonText => _formType == _FormType.login ? 'Login' : 'Create Account';
  String get _toggleText => _formType == _FormType.login ? 'New user? Create Account' : 'Already have an account? Login';

  // --- Mock Functions ---

  void _login() {
    // Dummy validation check (to prevent empty fields for demo)
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showMessage('Please enter email and password to log in.');
      return;
    }

    // Mock login flow: Navigate based on selected role
    String route = '/home/$selectedRole';
    // For a real app: Authenticate user via Firebase/API, save session, then navigate.
    _showMessage('Logging in as $selectedRole...');
    Navigator.pushReplacementNamed(context, route);
  }

  void _register() {
    // Dummy validation check
    if (emailController.text.isEmpty || passwordController.text.isEmpty || mobileController.text.isEmpty) {
      _showMessage('Please fill all fields to create an account.');
      return;
    }

    // Mock registration flow: For now, default new users to the citizen role.
    // For a real app: Register user via Firebase/API, log them in, save session.
    _showMessage('Creating account for ${emailController.text} and registering as citizen...');
    Navigator.pushReplacementNamed(context, '/home/citizen');
  }

  void _submitForm() {
    if (_formType == _FormType.login) {
      _login();
    } else {
      _register();
    }
  }

  void _toggleFormType() {
    setState(() {
      _formType = _formType == _FormType.login ? _FormType.register : _FormType.login;
      // Clear fields when switching forms for cleaner UI
      emailController.clear();
      passwordController.clear();
      mobileController.clear();
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // --- Widget Build ---

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
              Icon(
                _formType == _FormType.login ? Icons.account_circle : Icons.person_add_alt_1,
                size: 100,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 20),
              Text(
                _formType == _FormType.login ? 'CivicTrack Login' : 'Create New Account',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),

              // Role selector (only visible for Login)
              if (_formType == _FormType.login) ...[
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
              ],
              
              // Mobile Number Input (only visible for Register)
              if (_formType == _FormType.register) ...[
                TextField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    prefixIcon: const Icon(Icons.phone_android_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

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

              // Login/Register button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _buttonText,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Toggle between Login and Create Account
              TextButton(
                onPressed: _toggleFormType,
                child: Text(
                  _toggleText,
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Submit Anonymous Complaint button (always available)
              TextButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/submit/anonymous'),
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