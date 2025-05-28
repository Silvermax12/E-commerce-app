import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../components/square_tile.dart';
import '../components/user_data.dart';
import '../components/globals.dart';
import 'login_page.dart';
import 'main_screen.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void showErrorMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void handleFirebaseError(FirebaseAuthException e) {
    String message = 'Registration failed';
    switch (e.code) {
      case 'email-already-in-use':
        message = 'Email already registered';
        break;
      case 'invalid-email':
        message = 'Invalid email format';
        break;
      case 'weak-password':
        message = 'Password must be at least 6 characters';
        break;
      case 'operation-not-allowed':
        message = 'Email/password accounts are not enabled';
        break;
    }
    showErrorMessage(message);
  }

  Future<void> signUserUp() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Front-end validation
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final confirmPassword = confirmPasswordController.text.trim();

      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        Navigator.pop(context); // Dismiss loading dialog
        showErrorMessage("Please fill in all fields");
        return;
      }

      if (password != confirmPassword) {
        Navigator.pop(context);
        showErrorMessage("Passwords don't match");
        return;
      }

      if (password.length < 6) {
        Navigator.pop(context);
        showErrorMessage("Password must be at least 6 characters");
        return;
      }

      // Firebase registration
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Dismiss loading dialog before navigating
      Navigator.pop(context);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Dismiss loading dialog on error
      handleFirebaseError(e);
    } catch (e) {
      Navigator.pop(context);
      showErrorMessage("Registration failed: ${e.toString()}");
    }
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        final String userName = account.displayName ?? 'Unknown User';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Signed in as $userName')));
        // Navigate to HomeScreen on successful Google Sign-In.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
        userData.userName = account.displayName;
        globalUserName = account.displayName;
      }
    } catch (error) {
      print('Google Sign-In Error: $error');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Google Sign-In Failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // Logo
                const CircleAvatar(
                  radius: 65.0,
                  backgroundImage: AssetImage("lib/images/playstore.png"),
                ),
                const SizedBox(height: 30),
                Text(
                  'Welcome Human',
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                const SizedBox(height: 25),
                // Email textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  label: 'Email',
                ),
                const SizedBox(height: 10),
                // Password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  label: 'Password',
                ),
                const SizedBox(height: 10),
                // Confirm Password textfield using confirmPasswordController.
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                  label: 'Confirm Password',
                ),
                const SizedBox(height: 25),
                // Sign Up button.
                MyButton(text: "Sign Up", onTap: signUserUp),
                const SizedBox(height: 10),
                // Or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 0.5, color: Colors.grey[400]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(thickness: 0.5, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Google sign in button.
                GestureDetector(
                  onTap: () => _handleGoogleSignIn(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SquareTile(imagePath: 'lib/images/google.png'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Login prompt.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
