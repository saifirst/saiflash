// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saiflash/widgets/signup_form.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool obsecureText = true;
  var _userEmail = '';
  var _userPassword = '';
  var _isAuthenticating = false;
  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    setState(() {
      _isAuthenticating = true;
    });
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      setState(() {
        _isAuthenticating = false;
      });
      return;
    }
    _formKey.currentState!.save();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _userEmail, password: _userPassword);
      Navigator.pop(context);
    } on FirebaseAuthException catch (error) {
      var message = 'An error occurred, please check your credentials!';
      if (error.message != null) {
        message = error.message!;
      }
      ScaffoldMessenger.of(context).clearSnackBars();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.white,
              ),
        ),
      ));
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          color: Colors.white),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            thickness: 4,
            indent: 180,
            endIndent: 180,
            color: Color(0xffD3ACB3),
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 24, right: 24, bottom: keyboardHeight + 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome Back!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Your knowledge journey continues.',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(
                  height: 32,
                ),
                StatefulBuilder(
                  builder: (context, setState) => SingleChildScrollView(
                      child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                style: Theme.of(context).textTheme.bodySmall,
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                maxLines: 1,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 16),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Color(0xff333333))),
                                    labelText: 'Email',
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            color: const Color(0xff999999))),
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return 'Please enter a valid email address.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _userEmail = value!;
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                style: Theme.of(context).textTheme.bodySmall,
                                keyboardType: TextInputType.visiblePassword,
                                autocorrect: false,
                                maxLines: 1,
                                maxLength: 15,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: SvgPicture.asset(
                                        obsecureText
                                            ? 'assets/icons/password-eye-open.svg'
                                            : 'assets/icons/password-eye-close.svg',
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          obsecureText = !obsecureText;
                                        });
                                      },
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 16),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Color(0xff333333))),
                                    labelText: 'Password',
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            color: const Color(0xff999999))),
                                obscureText: obsecureText,
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 6) {
                                    return 'Password must be at least 6 characters long.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _userPassword = value!;
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _submit();
                                },
                                child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: const Color(0xff912F40)),
                                    child: _isAuthenticating
                                        ? const Center(
                                            child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white)),
                                          )
                                        : Text(
                                            textAlign: TextAlign.center,
                                            'Log in',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(color: Colors.white),
                                          )),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'don\'t have an account?',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 12),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (ctx) {
                                              return const SignUpForm();
                                            });
                                      },
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 0),
                                      ),
                                      child: Text(
                                        'Sign up',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: const Color(0xff912F40),
                                              fontSize: 12,
                                            ),
                                      ))
                                ],
                              )
                            ],
                          ))),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
