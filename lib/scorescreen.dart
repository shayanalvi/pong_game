import 'package:flutter/material.dart';

class Scorescreen extends StatelessWidget {
  final bool gameHasStarted;
  final int? enemyScore;
  final int? playerScore;

  Scorescreen(
      {super.key,
      required this.gameHasStarted,
      this.enemyScore,
      this.playerScore});

  @override
  Widget build(BuildContext context) {
    // Check if the game has started and return the widget accordingly
    return gameHasStarted
        ? Stack(
            children: [
              Container(
                alignment: Alignment(0, 0),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width / 4,
                  color: Colors.grey[800],
                ),
              ),
              Container(
                alignment: Alignment(0, -0.3),
                child: Text(
                  enemyScore?.toString() ?? '0',
                  style: TextStyle(color: Colors.grey[800], fontSize: 90),
                ),
              ),
              Container(
                alignment: Alignment(0, 0.3),
                child: Text(
                  playerScore?.toString() ?? '0',
                  style: TextStyle(color: Colors.grey[800], fontSize: 90),
                ),
              ),
            ],
          )
        : Container(); // Show an empty container if the game has not started
  }
}
