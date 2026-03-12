import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/common/widgets/loader.dart';
import 'package:my_app/core/utils/show_toast.dart';
import 'package:my_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:my_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:my_app/features/auth/presentation/pages/signup.dart';

class Login extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const Login(),
      );
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isHovered = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth > 600 ? 400 : screenWidth;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showToast(state.message);
            } else if (state is AuthSuccess) {
              if (!context.mounted) return;
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          },
          builder: (context, state) {
            return state is AuthLoading
                ? Loader()
                : Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(
                      child: Card(
                        color: Theme.of(context).colorScheme.primary,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          width: containerWidth,
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Center(
                                child: Text(
                                  'Log In',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              SizedBox(height: 20),
                              Form(
                                key: _loginkey,
                                child: Column(
                                  children: [
                                    // Email
                                    AuthField(
                                        hintText: 'Email',
                                        fieldController: _emailController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your email';
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
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your password';
                                          }
                                          return null;
                                        }),
                                    SizedBox(height: 20),

                                    // Log In Button
                                    AuthButton(
                                      buttonText: 'Log In',
                                      onPressed: () {
                                        if (_loginkey.currentState!
                                            .validate()) {
                                          context.read<AuthBloc>().add(
                                                AuthLogin(
                                                  email: _emailController.text
                                                      .trim(),
                                                  password: _passwordController
                                                      .text
                                                      .trim(),
                                                ),
                                              );
                                        }
                                      },
                                    ),

                                    SizedBox(height: 10),

                                    // Sign Up Navigation
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(context, Signup.route());
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
                                          'Create a new account',
                                          style: _isHovered
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              206,
                                                              115,
                                                              85),
                                                      decoration: TextDecoration
                                                          .underline,
                                                      decorationColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              206,
                                                              115,
                                                              85))
                                              : Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            10), // Add some space at the bottom for better balance
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
