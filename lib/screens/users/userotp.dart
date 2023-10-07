import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utility_corner/screens/users/userauth.dart';
import 'package:utility_corner/screens/users/usermain.dart';
import 'package:utility_corner/widgets/home_widgets.dart';
import 'package:pinput/pinput.dart';

class UserOTPScreen extends StatefulWidget {
  const UserOTPScreen({
    super.key,
    required this.verificationId,
  });

  final String verificationId;

  @override
  State<UserOTPScreen> createState() => _UserOTPScreenState();
}

class _UserOTPScreenState extends State<UserOTPScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var code = "";
  String otp = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(
          left: 25,
          right: 25,
        ),
        height: mediaHeight(1),
        width: mediaWidth(1),
        decoration: BoxDecoration(
          gradient: bigGradient(),
        ),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo_1.png',
                width: 230,
                height: 230,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Phone Verification",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 35,
              ),
              Pinput(
                length: 6,
                // defaultPinTheme: defaultPinTheme,
                // focusedPinTheme: focusedPinTheme,
                // submittedPinTheme: submittedPinTheme,
                onChanged: (value) {
                  code = value;
                },
                showCursor: true,
                onCompleted: (pin) => otp = pin,
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      try {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                          verificationId: widget.verificationId,
                          smsCode: code,
                        );
                        

                        if (otp == code) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => const UserMainScreen(),
                            ),
                          );

                          await auth.signInWithCredential(credential);
                        } else {
                          Get.snackbar("Error", "Invalid OTP");
                        }
                      } catch (e) {
                        Get.snackbar("error", "ERROR???????");
                      }
                    },
                    child: const Text("Verify Phone Number")),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => UserAuthScreen(isLogin: false,),
                          ),
                        );
                      },
                      child: const Text(
                        "Edit Phone Number ?",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              )
            ],
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
