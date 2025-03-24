import 'package:flutter/material.dart';

class CopingStrategiesScreen extends StatelessWidget {
  const CopingStrategiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC8E6C9),
      appBar: AppBar(
        title: const Text('Coping Strategies', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildCopingCard(
              title: 'Breathing Exercise',
              description: 'Try the 4-7-8 breathing technique: Inhale for 4 seconds, hold for 7 seconds, and exhale for 8 seconds.',
              icon: Icons.air,
            ),
            _buildCopingCard(
              title: 'Mindfulness Meditation',
              description: 'Spend 5 minutes focusing on your breath and surroundings to center yourself.',
              icon: Icons.self_improvement,
            ),
            _buildCopingCard(
              title: 'Quick Physical Activity',
              description: 'Take a short walk, stretch, or do a few jumping jacks to reset your energy.',
              icon: Icons.directions_walk,
            ),
            _buildCopingCard(
              title: 'Journaling',
              description: 'Write down your thoughts and emotions to process them better.',
              icon: Icons.book,
            ),
            _buildCopingCard(
              title: 'Music Therapy',
              description: 'Listen to calming or uplifting music to improve your mood.',
              icon: Icons.music_note,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCopingCard({required String title, required String description, required IconData icon}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(description, textAlign: TextAlign.justify),
          ),
        ],
      ),
    );
  }
  
}
