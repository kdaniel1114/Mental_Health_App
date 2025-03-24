import 'package:flutter/material.dart';
import '/db/database_helper.dart'; // Replace with actual path

class MoodCheckInScreen extends StatefulWidget {
  const MoodCheckInScreen({super.key});

  @override
  _MoodCheckInScreenState createState() => _MoodCheckInScreenState();
}

class _MoodCheckInScreenState extends State<MoodCheckInScreen> {
  int _selectedMood = -1;

  final List<Map<String, dynamic>> _moods = [
    {"emoji": "😃", "color": Color(0xFFFFD54F), "label": "Very Happy"},  // Warm golden yellow
{"emoji": "🙂", "color": Color(0xFFFFF176), "label": "Happy"},       // Soft pastel yellow
{"emoji": "😐", "color": Color(0xFFA5D6A7), "label": "Neutral"},     // Gentle pastel green
{"emoji": "🙁", "color": Color(0xFF81D4FA), "label": "Sad"},         // Light calming blue
{"emoji": "😢", "color": Color(0xFF64B5F6), "label": "Very Sad"},    // Soft sky blue
  ];

  final TextEditingController _noteController = TextEditingController();


  void _submitMood() async {
  if (_selectedMood != -1) {
    String moodLabel = _moods[_selectedMood]['label'];
    String note = _noteController.text.trim(); // Get note text

    await DatabaseHelper.instance.insertMood(moodLabel, note); 

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Mood checked in with note!")),
    );

    _noteController.clear(); // Clear input after saving
    setState(() {});
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mood Check-In"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 78, 172, 249), // Soft bright blue for a calming effect
        elevation: 2,
      ),
      backgroundColor: Color(0xFFE3F2FD), // Gentle sky blue for a friendly vibe
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Hello, User! How are you feeling today?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Check in with your emotions.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),

          const SizedBox(height: 30),

          // Mood Selection Area
          Center(
            child: Column(
              children: [
                const Text(
                  "Select Your Mood",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _moods.asMap().entries.map((entry) {
                    int index = entry.key;
                    var mood = entry.value;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMood = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _selectedMood == index
                              ? mood["color"].withOpacity(0.9)
                              : mood["color"].withOpacity(0.5),
                          shape: BoxShape.circle,
                          boxShadow: _selectedMood == index
                              ? [
                                  const BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 5,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [],
                        ),
                        child: Text(
                          mood["emoji"],
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
              
            ),
          ),

          const SizedBox(height: 40),

          // AI Insights Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "AI Insight:",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Try deep breathing for 5 minutes today.",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "View More",
                        style: TextStyle(color: Color(0xFF607D8B)), // Matches header
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          TextField(
  controller: _noteController,
  decoration: InputDecoration(
    hintText: "Write a note (optional)",
    border: OutlineInputBorder(),
  ),
  maxLines: 3,
),

const Spacer(),
          // Mood Submission Button
          Center(
            child: ElevatedButton(
              onPressed: _submitMood,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF607D8B), // Softer blue-gray
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 3,
              ),
              child: const Text(
                "Check In Now",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}