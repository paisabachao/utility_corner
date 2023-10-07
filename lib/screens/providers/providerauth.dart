import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utility_corner/screens/providers/providerotp.dart';
import 'package:utility_corner/widgets/home_widgets.dart';

final _firebase = FirebaseAuth.instance;

// ignore: must_be_immutable
class ProviderAuthScreen extends StatefulWidget {
  ProviderAuthScreen({super.key, required this.isLogin});

  bool isLogin;
  @override
  State<ProviderAuthScreen> createState() => _ProviderAuthScreenState();
}

class _ProviderAuthScreenState extends State<ProviderAuthScreen> {
  final _form = GlobalKey<FormState>();

  var _enteredName = '';
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  var _enteredMobileNo = '';
  var _isAuthenticating = false;

  // static String verify = "";

  void _submit() async {
    final isValid = _form.currentState!.validate();
    final UserCredential providerCredentials;

    if (!isValid) {
      print('RETURNEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD');
      return;
    }

    _form.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });

      if (widget.isLogin) {
        // providerCredentials = await _firebase.signInWithEmailAndPassword(
        //   email: _enteredEmail,
        //   password: _enteredPassword,
        // );
        providerCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        print('login');
      } else {
        providerCredentials =
            await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );

        await FirebaseFirestore.instance
            .collection('providers')
            .doc(providerCredentials.user!.uid)
            .set({
          'provider_name': _enteredName,
          'provider_email': _enteredEmail,
          'provider_password': _enteredPassword,
          'provider_user_name': _enteredUsername,
          'provider_mobile_No': _enteredMobileNo,
        });

        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: _enteredMobileNo,
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {},
          codeSent: (String verificationId, int? resendToken) {
            // _ProviderAuthScreenState.verify =
            //     verificationId;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => ProviderOTPScreen(
                  verificationId: verificationId,
                  remail: _enteredEmail,
                  rpassword: _enteredPassword,
                ),
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );

        print('signup');
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        // ...
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).clearSnackBars();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed'),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: mediaHeight(1),
            decoration: BoxDecoration(
              gradient: bigGradient(),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                    bottom: 10,
                    left: 20,
                    right: 20,
                  ),
                  width: 210,
                  child: Image.asset('assets/images/logo_1.png'),
                ),
                Card(
                  margin: const EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Form(
                        key: _form,
                        child: Column(
                          children: [
                            //user name
                            if (!widget.isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Your Name',
                                ),
                                keyboardType: TextInputType.name,
                                autocorrect: true,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter a valid name.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredName = value!;
                                },
                              ),

                            // user email
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Email Address',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return 'Please enter a valid email address.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredEmail = value!;
                              },
                            ),

                            // user username
                            if (!widget.isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                ),
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length < 4) {
                                    return 'Please enter at least 4 characters.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredUsername = value!;
                                },
                              ),

                            // user password
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: widget.isLogin
                                    ? 'Password'
                                    : 'New Password',
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return 'Password must be at least 6 characters long.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredPassword = value!;
                              },
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            // user mobile number
                            if (!widget.isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Mobile Number',
                                ),
                                obscureText: false,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 10 ||
                                      value.trim().length > 10) {
                                    return 'Mobile Number must be 10 digits long.';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) {
                                  _enteredMobileNo = '+91$value';
                                },
                              ),

                            const SizedBox(
                              height: 25,
                            ),

                            if (_isAuthenticating)
                              const CircularProgressIndicator(),
                            if (!_isAuthenticating)
                              ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                child:
                                    Text(widget.isLogin ? 'Login' : 'Signup'),
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (!_isAuthenticating)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    widget.isLogin = !widget.isLogin;
                                  });
                                },
                                child: Text(widget.isLogin
                                    ? 'Create an account'
                                    : 'I already have an account'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  mediaHeight(double d) {
    return MediaQuery.of(context).size.height * d;
  }

  mediaWidth(double d) {
    return MediaQuery.of(context).size.width * d;
  }
}
