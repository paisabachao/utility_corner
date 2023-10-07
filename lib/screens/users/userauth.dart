import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utility_corner/screens/users/userotp.dart';
import 'package:utility_corner/widgets/home_widgets.dart';

// ignore: must_be_immutable
class UserAuthScreen extends StatefulWidget {
  UserAuthScreen({super.key, required this.isLogin});

  bool isLogin;
  
  @override
  State<UserAuthScreen> createState() => _UserAuthScreenState();
}

class _UserAuthScreenState extends State<UserAuthScreen> {
  final _form = GlobalKey<FormState>();

  //var isLogin = true;
  var _enteredName = '';
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  var _enteredMobileNo = '';
  var _isAuthenticating = false;

  static String verify = "";

  

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
                    top: 30,
                    bottom: 10,
                    left: 20,
                    right: 20,
                  ),
                  width: 230,
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
                                labelText:
                                    widget.isLogin ? 'Password' : 'New Password',
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
                                onPressed: () async {
                                  await FirebaseAuth.instance.verifyPhoneNumber(
                                    phoneNumber: _enteredMobileNo,
                                    verificationCompleted:
                                        (PhoneAuthCredential credential) {},
                                    verificationFailed:
                                        (FirebaseAuthException e) {},
                                    codeSent: (String verificationId,
                                        int? resendToken) {
                                      _UserAuthScreenState.verify =
                                          verificationId;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) => UserOTPScreen(
                                            verificationId: verificationId,
                                          ),
                                        ),
                                      );
                                    },
                                    codeAutoRetrievalTimeout:
                                        (String verificationId) {},
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                child: Text(widget.isLogin ? 'Login' : 'Signup'),
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
