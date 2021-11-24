import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 300.0,
              height: 300.0,
            ),
            const Text(
              "A SIMPLE OFFLINE MUSIC PLAYER",
              style: TextStyle(
                fontSize: 14.0,
                letterSpacing: 3.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 16.0,
              ),
              child: CircularProgressIndicator(
                backgroundColor: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
