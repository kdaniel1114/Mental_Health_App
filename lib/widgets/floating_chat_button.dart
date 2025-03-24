import 'package:flutter/material.dart';

class FloatingChatButton extends StatelessWidget {
  final String currentScreen;

  const FloatingChatButton({super.key, required this.currentScreen});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Navigate to Chat Screen when clicked
        Navigator.pushNamed(context, '/chat');
      },
      backgroundColor: Colors.blue,
      child: Icon(Icons.chat, color: Colors.white),
    );
  }
}