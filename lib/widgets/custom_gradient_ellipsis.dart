import 'package:flutter/material.dart';

class CustomGradientEllipsis extends StatelessWidget {
  const CustomGradientEllipsis({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -150,
      child: Container(
        width: 430,
        height: 149,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(40, 10, 80, 1), // darker top
              Color.fromRGBO(30, 8, 60, 1),
              Color.fromRGBO(20, 5, 45, 1),
              Color.fromRGBO(10, 2, 25, 1), // very dark bottom
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(120, 60, 200, 0.9), // brighter purple glow
              offset: Offset(0, 0),
              blurRadius: 250,
              spreadRadius: 120,
            ),
          ],
          shape: BoxShape.circle,
        ),
      ),
    );
  }

}


