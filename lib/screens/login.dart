import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/helpers/app_regex.dart';
import 'package:flutter_demo/helpers/helper_service.dart';
import 'package:flutter_demo/themes/styles.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../main.dart';
import 'dart:ui';
import 'package:flutter_demo/widgets/common_header.dart';

/// Login screen widget that handles user authentication and registration.
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

/// Represents a user with username, email, and password.
class User {
  String username;
  String email;
  String password;

  User({required this.username, required this.email, required this.password});
}

/// State class for Login, manages login, signup, and UI transitions.
class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController =
      TextEditingController(text: '');
  final TextEditingController _passwordController =
      TextEditingController(text: '');
  final TextEditingController _rePasswordController =
      TextEditingController(text: '');
  final TextEditingController _emailController =
      TextEditingController(text: '');
  bool login1 = true;
  HelperService helperService = HelperService();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Attempts to log in the user with the provided username and password.
  Future<bool> login(String username, String password) async {
    try {
      await Parse().initialize(applicationId, parseURL,
          clientKey: clientKey, autoSendSessionId: true);

      final parseUser = ParseUser(username, password, null);
      final result = await parseUser.login();
      return result.success;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// Logs out the current user.
  Future<bool> logout() async {
    try {
      final ParseUser parseUser = await ParseUser.currentUser();
      final result = await parseUser.logout();
      return result.success;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// Registers a new user with the provided user information.
  Future<bool> signup(User user) async {
    try {
      await Parse().initialize(applicationId, parseURL,
          clientKey: clientKey, autoSendSessionId: true);

      final parseUser = ParseUser(user.username, user.password, user.email);
      final result = await parseUser.signUp();
      return result.success;
    } catch (e) {
      // Handle error
      print(e);
      return false;
    }
  }

  /// Returns the signup form widget tree.
  List<Widget> signupForm() {
    const double height = 60;
    const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 30);
    final InputDecoration inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      labelStyle: TextStyle(color: Colors.blueGrey.shade700),
      contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent.shade100, width: 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      prefixIconColor: Colors.blueAccent,
    );
    return [
      FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Card(
            elevation: 12,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Sign Up',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent.shade700,
                        letterSpacing: 1.5,
                      )),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _usernameController,
                    keyboardType: TextInputType.text,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Username',
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    obscureText: true,
                    controller: _rePasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Re-enter Password',
                      prefixIcon: const Icon(Icons.lock_reset),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        elevation: WidgetStateProperty.all(8),
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.pressed)) {
                              return Colors.blueAccent.shade700;
                            }
                            return Colors.blueAccent;
                          },
                        ),
                      ),
                      onPressed: () async {
                        String username = _usernameController.text.trim().toLowerCase();
                        String password = _passwordController.text;
                        String rePassword = _rePasswordController.text;
                        String email = _emailController.text.trim().toLowerCase();
                        if (password != rePassword) {
                          helperService.showMessage(
                              context, 'Password and Re-password do not match.',
                              error: true);
                          return;
                        }
                        if (!AppRegexHelper.isEmailValid(email)) {
                          helperService.showMessage(context, 'Please provide valid email.',
                              error: true);
                          return;
                        }
                        if (!AppRegexHelper.hasMinLength(password) ||
                            !AppRegexHelper.hasMinLength(rePassword)) {
                          helperService.showMessage(
                              context, 'Please provide at least 6 characters in password.',
                              error: true);
                          return;
                        }

                        User user =
                            User(username: username, email: email, password: password);
                        signup(user).then((success) {
                          if (success) {
                            _passwordController.clear();
                            _rePasswordController.clear();
                            _emailController.clear();
                            setState(() {
                              login1 = true;
                            });
                            helperService.showMessage(
                                context, 'Signup successful, please login.');
                          } else {
                            helperService.showMessage(context,
                                'Username or email already exists, please try again.',
                                error: true);
                          }
                        });
                        await AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.rightSlide,
                          title: 'Sign up Success',
                          desc: 'You have successfully signed up.',
                        ).show();
                      },
                      child: const Text('Sign Up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        login1 = true;
                      });
                    },
                    child: const Text('Already have an account?', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ];
  }

  /// Returns the login form widget tree.
  List<Widget> loginForm() {
    const double height = 100;
    const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 30);
    final InputDecoration inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      labelStyle: TextStyle(color: Colors.blueGrey.shade700),
      contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent.shade100, width: 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      prefixIconColor: Colors.blueAccent,
    );
    return [
      FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Card(
            elevation: 12,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Login',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent.shade700,
                        letterSpacing: 1.5,
                      )),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _usernameController,
                    keyboardType: TextInputType.text,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Username',
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        elevation: WidgetStateProperty.all(8),
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.pressed)) {
                              return Colors.blueAccent.shade700;
                            }
                            return Colors.blueAccent;
                          },
                        ),
                      ),
                      onPressed: () async {
                        String username = _usernameController.text.trim().toLowerCase();
                        String password = _passwordController.text;

                        login(username, password).then((success) {
                          if (success) {
                            // helperService.showMessage(context, 'Login Successful.');
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.rightSlide,
                              title: 'Login Success',
                              desc: 'You have successfully Logged up.',
                            ).show();
                            Navigator.of(context).pushReplacementNamed("/");
                          } else {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'Wrong username or password provided.',
                            ).show();
                          }
                        });
                      },
                      child: const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        login1 = false;
                      });
                    },
                    child: const Text('Signup?', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFe3f0ff), Color(0xFFf8fbff)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CommonHeader(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              ...login1 ? loginForm() : signupForm(),
            ],
          ),
        ),
      ),
    );
  }
}
