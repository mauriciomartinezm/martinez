import 'package:flutter/material.dart';

class AuthAvatar extends StatelessWidget {
  const AuthAvatar({super.key, this.radius = 56});

  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFE0E0E0),
      child: Icon(
        Icons.person,
        size: radius,
        color: Colors.grey[700],
      ),
    );
  }
}
