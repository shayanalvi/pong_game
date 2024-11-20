import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Stack(
          children: [
            Container(
              alignment: Alignment(0, 0),
              child: Container(
                color: Colors.white,
                height: 20,
                width: MediaQuery.of(context).size.width / 5,
              ),
            )
          ],
        ),
      ),
    );
  }
}
