import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';

enum AuthMode { SignUp, Login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var authMode = AuthMode.Login;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  void _switchAuthMode() {
    if (authMode == AuthMode.Login) {
      setState(() {
        authMode = AuthMode.SignUp;
      });
    } else {
      setState(() {
        authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.secondary.withOpacity(0.6),
              Colors.orangeAccent.withOpacity(0.4),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              height: 400,
              child: Form(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email)),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        controller: emailController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        textInputAction: authMode == AuthMode.Login
                            ? TextInputAction.done
                            : TextInputAction.next,
                        controller: passwordController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (authMode == AuthMode.SignUp)
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Confirm Password",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (authMode == AuthMode.SignUp) {
                              Provider.of<AuthProvider>(context, listen: false)
                                  .signUp(
                                emailController.text,
                                passwordController.text,
                              );
                            } else {
                              Provider.of<AuthProvider>(context, listen: false)
                                  .login(
                                emailController.text,
                                passwordController.text,
                              );
                            }
                          },
                          child: Text(
                            authMode == AuthMode.Login ? "Login" : "Signup",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            authMode == AuthMode.Login
                                ? "Don't have an account?"
                                : "Already have an account?",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: _switchAuthMode,
                            child: Text(
                              authMode == AuthMode.Login ? "Join now" : "Login",
                              style: const TextStyle(
                                fontSize: 16,
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
          ),
        ),
      ),
    );
  }
}
