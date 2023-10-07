import 'package:flutter/material.dart';
import 'package:utility_corner/screens/providers/providerauth.dart';
import 'package:utility_corner/screens/users/userauth.dart';
import 'package:utility_corner/widgets/home_widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: mediaHeight(1),
        width: mediaWidth(1),
        decoration: BoxDecoration(
          gradient: bigGradient(),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              Image.asset(
                'assets/images/logo_1.png',
                height: mediaHeight(0.50),
              ),
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserAuthScreen(
                        isLogin: true,
                      ),
                    ),
                  );
                },
                child: buttons(
                  'CUSTOMER',
                  Colors.white,
                  darkBlue,
                  mediaWidth(0.85),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProviderAuthScreen(isLogin: true,),
                    ),
                  );
                },
                child: buttons(
                  'PROVIDER',
                  darkBlue,
                  Colors.white,
                  mediaWidth(0.85),
                ),
              ),
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
