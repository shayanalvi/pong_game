// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ponggame/ball.dart';
import 'package:ponggame/brick.dart';
import 'package:ponggame/coverscreen.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

enum direction { UP, DOWN, LEFT, RIGHT }

class _HomepageState extends State<Homepage> {
  // Player variables (bottom brick)
  double playerX = 0;

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
    });
  }

  void updateDirection() {
    setState(() {
      // update vertical direction
      if (ballY >= 0.9) {
        ballYDirection = direction.UP;
      } else if (ballY <= -0.9) {
        ballYDirection = direction.DOWN;
      }

      //updating the horizontal direction
      if (ballX >= 1) {
        ballXDirection = direction.LEFT;
      } else if (ballX <= -1) {
        ballXDirection = direction.RIGHT;
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

                // Top brick
                MyBrick(x: 0, y: -0.9),

                // Bottom brick
                MyBrick(x: playerX, y: 0.9),

                // Ball
                MyBall(x: ballX, y: ballY),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
