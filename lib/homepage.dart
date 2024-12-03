// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ponggame/ball.dart';
import 'package:ponggame/brick.dart';
import 'package:ponggame/coverscreen.dart';
import 'package:ponggame/scorescreen.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

enum direction { UP, DOWN, LEFT, RIGHT }

class _HomepageState extends State<Homepage> {
  // Player variables (bottom brick)
  double playerX = -0.2;
  double brickWidth = 0.4;
  int playerScore = 0;

  //enemy variables

  double enemyX = -0.2;
  int enemyScore = 0;

  // Ball variables
  double ballX = 0;
  double ballY = 0;
  var ballYDirection = direction.DOWN;
  var ballXDirection = direction.LEFT;

  // Game settings
  bool gameHasStarted = false;

  // Focus node for RawKeyboardListener
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose(); // Dispose of the FocusNode when the widget is removed
    super.dispose();
  }

  void startGame() {
    setState(() {
      gameHasStarted = true;
    });

    Timer.periodic(Duration(milliseconds: 16), (timer) {
      // Update direction
      updateDirection();

      // Move ball
      moveBall();

      // move enemy

      moveEnemy();

      // Check if player is dead
      if (isPlayerDead()) {
        enemyScore++;
        timer.cancel(); // Stop the timer (game over)
        _showDialog(false); // Show the dialog
      }
      if (isEnemyDead()) {
        playerScore++;
        timer.cancel();
        _showDialog(true);
      }
    });
  }

  bool isEnemyDead() {
    if (ballY <= -1) {
      return true;
    }
    return false;
  }

  void moveEnemy() {
    setState(() {
      enemyX = ballX;
    });
  }

  void _showDialog(bool enemyDied) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevents the user from dismissing the dialog by tapping outside it
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              enemyDied ? "PURPLE WIN" : "Purple Win",
              style: TextStyle(color: Colors.white),
            ), // Text
          ), // Center
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Close the dialog
                resetGame(); // Reset the game state
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding: EdgeInsets.all(7),
                  color: enemyDied ? Colors.pink[100] : Colors.deepPurple,
                  child: Text(
                    'PLAY AGAIN',
                    style: TextStyle(
                      color:
                          enemyDied ? Colors.pink[800] : Colors.deepPurple[800],
                    ),
                  ), // Text
                ), // Container
              ), // ClipRRect
            ), // GestureDetector
          ], // actions
        ); // AlertDialog
      },
    );
  }

  void resetGame() {
    setState(() {
      gameHasStarted = false;
      ballX = 0;
      ballY = 0;
      playerX = -0.2;
      enemyX = -0.2;
    });
  }

  bool isPlayerDead() {
    // Game should end when the ball falls below the screen, not when it touches the right side
    if (ballY >= 1) {
      return true; // Player is dead if the ball goes beyond the bottom
    }

    return false;
  }

  void updateDirection() {
    setState(() {
      // update vertical direction
      if (ballY >= 0.9 && playerX + brickWidth >= ballX && playerX <= ballX) {
        ballYDirection = direction.UP;
      } else if (ballY <= -0.9) {
        ballYDirection = direction.DOWN;
      }

      // Update horizontal direction
      // The ball bounces when hitting the left or right screen boundaries
      if (ballX >= 1) {
        ballXDirection = direction.LEFT; // Bounce ball to the left
      } else if (ballX <= -1) {
        ballXDirection = direction.RIGHT; // Bounce ball to the right
      }
    });
  }

  void moveBall() {
    setState(() {
      //vert movmement
      if (ballYDirection == direction.DOWN) {
        ballY += 0.01;
      } else if (ballYDirection == direction.UP) {
        ballY -= 0.01;
      }
      //horizontal movement

      if (ballXDirection == direction.LEFT) {
        ballX -= 0.01;
      } else if (ballXDirection == direction.RIGHT) {
        ballX += 0.01;
      }
    });
  }

  void moveLeft() {
    setState(() {
      playerX = (playerX - 0.1)
          .clamp(-1.0, 1.0); // Prevent player from moving out of bounds
    });
  }

  void moveRight() {
    setState(() {
      playerX = (playerX + 0.1)
          .clamp(-1.0, 1.0); // Prevent player from moving out of bounds
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKey: (event) {
        if (event is RawKeyDownEvent) {
          if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
            moveLeft();
          } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
            moveRight();
          }
        }
      },
      child: GestureDetector(
        onTap: startGame,
        child: Scaffold(
          backgroundColor: Colors.grey[900],
          body: Center(
            child: Stack(
              children: [
                // Tap to play
                Coverscreen(
                  gameHasStarted: gameHasStarted,
                ),

                //score screen

                Scorescreen(
                  gameHasStarted: gameHasStarted,
                  enemyScore: enemyScore,
                  playerScore: playerScore,
                ),
                // Top brick
                MyBrick(
                  x: enemyX,
                  y: -0.9,
                  brickWidth: brickWidth,
                  thisIsEnemy: true,
                ),

                // Bottom brick
                MyBrick(
                  x: playerX,
                  y: 0.9,
                  brickWidth: brickWidth,
                  thisIsEnemy: false,
                ),

                // Ball
                MyBall(
                  x: ballX,
                  y: ballY,
                  gameHasStarted: gameHasStarted,
                ),
                Container(
                  alignment: Alignment(playerX, 0.9),
                  child: Container(
                    width: 2,
                    height: 20,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
