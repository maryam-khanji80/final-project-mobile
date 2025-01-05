import 'package:flutter/material.dart';
import 'package:maryam/HomePage.dart';


class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/welcome.png', 
              height: 200,
              width: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Our Program',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()), 
                );
              },
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
