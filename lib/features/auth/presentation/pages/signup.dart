import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/common/widgets/loader.dart';
import 'package:my_app/core/utils/show_toast.dart';
import 'package:my_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:my_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:my_app/features/auth/presentation/pages/login.dart';

class Signup extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const Signup(),
      );
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _signupkey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isHovered = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      debugPrint("User created: ${userCredential.user}");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'Signup Successful!',
            style: Theme.of(context).textTheme.bodyMedium,
          )),
        );
      }

      // Redirect to login screen after a short delay
      await Future.delayed(Duration(seconds: 2));
      if (mounted) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Signup failed. Please try again.";

      if (e.code == 'email-already-in-use') {
        errorMessage = "User already exists";
      } else if (e.code == 'network-request-failed') {
        errorMessage = "Network error, please try again later.";
      } else {
        debugPrint('Error Code: ${e.code}');
        debugPrint('Error Message: ${e.message}');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            errorMessage,
            style: Theme.of(context).textTheme.bodyMedium,
          )),
        );
      }
    } catch (e) {
      debugPrint("Unexpected error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            "Signup failed. Please try again.",
            style: Theme.of(context).textTheme.bodyMedium,
          )),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth > 600 ? 400 : screenWidth;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Card(
              color: Theme.of(context).colorScheme.primary,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height *
                      0.8, // Adjust height dynamically
                ),

                width: containerWidth,
                padding: const EdgeInsets.all(14.0), // Uniform padding
                child: SingleChildScrollView(
                  child: Column(
                    // Change from fixed height to flexible height
                    mainAxisSize: MainAxisSize
                        .min, // Allows it to shrink or expand based on content
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Sign Up',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      SizedBox(height: 20),
                      BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is AuthFailure) {
                            showToast(state.message);
                          }
                        },
                        builder: (context, state) {
                          return state is AuthLoading
                              ? Loader()
                              : Form(
                                  key: _signupkey,
                                  child: Column(
                                    children: [
                                      // Full Name
                                      AuthField(
                                          hintText: 'Full Name',
                                          fieldController: _nameController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your full name';
                                            }
                                            return null;
                                          }),
                                      SizedBox(height: 16),

                                      // Email
                                      AuthField(
                                          hintText: 'Email',
                                          fieldController: _emailController,
                                          validator: (value) {
                                            String pattern =
                                                r'^[a-z]+[0-9]*(_?[0-9]+)*(\.[a-z]+[0-9]*(_?[0-9]+)*)*@[a-z0-9-]+\.[a-z]{2,}$';

                                            RegExp regex = RegExp(pattern);
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your email';
                                            }
                                            if (!regex.hasMatch(value)) {
                                              return 'Please enter a valid email';
                                            }
                                            return null;
                                          }),
                                      SizedBox(height: 16),

                                      // Password
                                      AuthField(
                                          isObscureText: true,
                                          hintText: 'Password',
                                          fieldController: _passwordController,
                                          validator: (value) {
                                            String pattern =
                                                r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%\^&\*\(\)_\+\-\=\[\]\{\};:\",<>./?\\|`~])';
                                            RegExp regex = RegExp(pattern);
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your password';
                                            }
                                            if (_passwordController
                                                    .text.length <
                                                8) {
                                              return 'Password must be at least 8 characters long';
                                            }
                                            if (!regex.hasMatch(value)) {
                                              return 'Password must include uppercase, lowercase, numbers, and special characters';
                                            }
                                            return null;
                                          }),
                                      SizedBox(height: 16),

                                      // Confirm Password
                                      AuthField(
                                        isObscureText: true,
                                        fieldController:
                                            _confirmPasswordController,
                                        hintText: 'Confirm Password',
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please confirm your password';
                                          }
                                          if (value !=
                                              _passwordController.text) {
                                            return 'Passwords do not match';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 20),

                                      // Sign Up Button
                                      AuthButton(
                                        buttonText: 'Sign Up',
                                        onPressed: () {
                                          if (_signupkey.currentState!
                                              .validate()) {
                                            context.read<AuthBloc>().add(
                                                  AuthSignUp(
                                                    name: _nameController.text
                                                        .trim(),
                                                    email: _emailController.text
                                                        .trim(),
                                                    password:
                                                        _passwordController.text
                                                            .trim(),
                                                  ),
                                                );
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                              builder: (context) =>
                                                  const Login(),
                                            ));
                                          }
                                        },
                                      ),

                                      SizedBox(height: 10),

                                      // Log In Navigation
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Already have an account? ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context, Login.route());
                                            },
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets
                                                  .zero, // Remove default padding
                                              minimumSize: Size
                                                  .zero, // Remove minimum size constraints
                                              tapTargetSize: MaterialTapTargetSize
                                                  .shrinkWrap, // Shrink tap target size
                                              foregroundColor: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.color,
                                              overlayColor: Colors.transparent,
                                            ),
                                            child: MouseRegion(
                                              onEnter: (_) {
                                                setState(() {
                                                  _isHovered = true;
                                                });
                                              },
                                              onExit: (_) {
                                                setState(() {
                                                  _isHovered = false;
                                                });
                                              },
                                              child: Text(
                                                'Log In',
                                                style: _isHovered
                                                    ? Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                            color: Colors
                                                                .blueAccent,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            decorationColor:
                                                                Colors
                                                                    .blueAccent)
                                                    : Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height:
                                              10), // Add some space at the bottom for better balance
                                    ],
                                  ),
                                );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
