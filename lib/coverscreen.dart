import 'package:flutter/material.dart';

class Coverscreen extends StatelessWidget {
  final bool gameHasStarted;

  Coverscreen({required this.gameHasStarted});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, -0.2),
      child: Text(
        gameHasStarted ? '' : 'T A P  T O  P L A Y',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
