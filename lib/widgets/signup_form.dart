// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saiflash/widgets/login_form.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool obsecureText = true;
  final _formKey = GlobalKey<FormState>();
  var _userName = '';
  var _userEmail = '';
  var _userPassword = '';

  var _isAuthenticating = false;

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
      final userCredentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _userEmail, password: _userPassword);
      Navigator.pop(context);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set({'Name': _userName, 'Email': _userEmail, 'Profile Picture': ''});
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
    }
    setState(() {
      _isAuthenticating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            color: Colors.white),
        width: double.infinity,
        child: Column(
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
                    'Create an Account',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Ready to master some new topics?',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  StatefulBuilder(
                    builder: (context, setState) => Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              style: Theme.of(context).textTheme.bodySmall,
                              keyboardType: TextInputType.name,
                              autocorrect: false,
                              maxLines: 1,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 16),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          color: Color(0xff333333))),
                                  labelText: 'Name',
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color: const Color(0xff999999))),
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              onSaved: (newValue) => _userName = newValue!,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
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
                                if (value == null ||
                                    value.isEmpty ||
                                    !value.contains('@')) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              onSaved: (newValue) => _userEmail = newValue!,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              style: Theme.of(context).textTheme.bodySmall,
                              keyboardType: TextInputType.visiblePassword,
                              autocorrect: false,
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
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                              onSaved: (newValue) => _userPassword = newValue!,
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: const Color(0xff912F40)),
                                  child: _isAuthenticating
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white)),
                                        )
                                      : Text(
                                          textAlign: TextAlign.center,
                                          'Sign up',
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
                                  'already have an account?',
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
                                            return const LoginForm();
                                          });
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 0),
                                    ),
                                    child: Text(
                                      'Log in',
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
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
