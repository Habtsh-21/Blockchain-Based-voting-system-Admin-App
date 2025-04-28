import 'package:blockchain_based_national_election_admin_app/features/auth/presentation/provider/provider.dart';
import 'package:blockchain_based_national_election_admin_app/features/auth/presentation/provider/provider_state.dart';
import 'package:blockchain_based_national_election_admin_app/features/auth/presentation/widgets/gradient_button.dart';
import 'package:blockchain_based_national_election_admin_app/features/auth/presentation/widgets/textForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final pState = ref.watch(providerStateProvider);
    final supabase = Supabase.instance.client;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.08,
                    vertical: height * 0.06,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            const Icon(
                              Icons.login_outlined,
                              size: 100,
                              color: Color.fromARGB(255, 186, 9, 153),
                            ),
                            SizedBox(height: height * 0.005),
                            const Text(
                              'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: height * 0.002),
                            const Text(
                              'Please your Information',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: _emailController,
                                labelText: 'Email',
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Invalid Email';
                                  }
                                  if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                  ).hasMatch(value)) {
                                    return 'Invalid Email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: height * 0.02),
                              CustomTextField(
                                controller: _passwordController,
                                labelText: 'Password',
                                keyboardType: TextInputType.name,
                                obscureText: isPasswordVisible,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter valid password';
                                  }

                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(child: Container()),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GradientButton(
                              text: pState is LoggingInState
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : const Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                              onPress: () async {
                                if (_formKey.currentState!.validate()) {
                                  print('1');

                                  print(
                                      'Trying login with: ${_emailController.text}/${_passwordController.text}');
                                  // try {
                                  //   final response = await supabase.auth
                                  //       .signInWithPassword(
                                  //           email: _emailController.text,
                                  //           password: _passwordController.text);
                                  //   if (response.user != null) {
                                  //     print('loggedin');
                                  //   }
                                  // } on AuthException catch (e) {
                                  //   print(
                                  //       'auth exception: code=${e.code}, message=${e.message}');
                                  //   final message = e.message.toLowerCase();
                                  //   if (message.contains(
                                  //       'invalid login credentials')) {
                                  //     print('invalid login credentials');
                                  //   } else if (message
                                  //       .contains('invalid email')) {
                                  //     print('invalid email');
                                  //   } else if (message
                                  //       .contains('user not found')) {
                                  //     print('user not found');
                                  //   } else if (message.contains(
                                  //           'email already registered') ||
                                  //       message
                                  //           .contains('already registered')) {
                                  //        print('email already registered');
                                  //   } else if (message
                                  //       .contains('signups not allowed')) {
                                  //        print('signups not allowed');
                                  //   } else if (message
                                  //       .contains('too many requests')) {
                                  //       print('too many requests');
                                  //   } else {
                                  //      print('server ');
                                  //   }
                                  // } catch (e) {
                                  //   print('Other error: $e');
                                  //      print('other error');
                                  // }
                                  ref
                                        .read(providerStateProvider.notifier)
                                        .login(_emailController.text, _passwordController.text);
                                  print("2");
                                }
                              },
                            ),
                            SizedBox(height: height * 0.02),
                            if (pState is FailureState)
                              Text(
                                pState.message,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            if (pState is LoggedInState)
                              const Text(
                                'LoggedIn',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                ),
                              )
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
      ),
    );
  }
}
