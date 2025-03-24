import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '/db/database_helper.dart';
import 'package:intl/intl.dart';

class MoodHistoryScreen extends StatefulWidget {
  const MoodHistoryScreen({super.key});

  @override
  _MoodHistoryScreenState createState() => _MoodHistoryScreenState();
}

class _MoodHistoryScreenState extends State<MoodHistoryScreen> {
  int _selectedTab = 0; // 0 = Journal, 1 = Trends
  bool _showWeekly = true; // Toggle for Weekly/Monthly
  List<Map<String, dynamic>> _moods = [];

  @override
  void initState() {
    super.initState();
    _fetchMoods();
  }

  Future<void> _fetchMoods() async {
    try {
      final List<Map<String, dynamic>> moods = await DatabaseHelper.instance.getAllMoods();
      setState(() {
        _moods = moods;
      });
    } catch (e) {
      print("Error fetching moods: $e");
    }
  }
  String _formatDate(int index) {
  DateTime date = _convertToDateTime(_moods[index]['timestamp'] ?? '');
  return DateFormat("MM/dd").format(date);
}
  DateTime _convertToDateTime(String timestamp) {
    try {
      return DateTime.parse(timestamp);
    } catch (e) {
      print("Date parsing error: $e");
      return DateTime.now();
    }
  }

  int _mapEmojiToLevel(String emoji) {
    const moodMap = {
      "😢": 1,
      "😞": 2,
      "😐": 3,
      "😊": 4,
      "😄": 5,
    };
    return moodMap[emoji] ?? 3;
  }

  List<FlSpot> _getMoodData() {
    final now = DateTime.now();
    final filteredMoods = _moods.where((mood) {
      final date = _convertToDateTime(mood['timestamp'] ?? '');
      if (_showWeekly) {
        return date.isAfter(now.subtract(const Duration(days: 7)));
      } else {
        return date.isAfter(now.subtract(const Duration(days: 30)));
      }
    }).toList();

    filteredMoods.sort((a, b) => _convertToDateTime(a['timestamp']).compareTo(_convertToDateTime(b['timestamp'])));

    return filteredMoods.map((mood) {
  final date = _convertToDateTime(mood['timestamp'] ?? '');
  final moodLevel = _mapEmojiToLevel(mood['mood'] ?? '😐');
  return FlSpot(date.millisecondsSinceEpoch.toDouble(), moodLevel.toDouble());
}).toList();
  }

  Widget _tabButton(String title, int index) {
    return TextButton(
      onPressed: () => setState(() => _selectedTab = index),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: _selectedTab == index ? Colors.purple : Colors.black,
        ),
      ),
    );
  }

  Widget _buildJournalScreen() {
    var sortedMoods = List<Map<String, dynamic>>.from(_moods);
    sortedMoods.sort((a, b) => (b["timestamp"] ?? "").compareTo(a["timestamp"] ?? ""));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedMoods.length,
      itemBuilder: (context, index) {
        var entry = sortedMoods[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Text(entry["mood"] ?? "❓", style: const TextStyle(fontSize: 24)),
            title: Text(
              DateFormat("yyyy-MM-dd HH:mm").format(_convertToDateTime(entry["timestamp"] ?? "")),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(entry["note"] ?? "No notes available"),
          ),
        );
      },
    );
  }

  Widget _buildMoodTrends() {
    return Column(
      children: [
        SwitchListTile(
          title: Text(_showWeekly ? "Showing: Weekly Trends" : "Showing: Monthly Trends"),
          value: _showWeekly,
          onChanged: (value) => setState(() => _showWeekly = value),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    axisNameWidget: const Text('Mood Level'),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameWidget: const Text('Date'),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
  int index = value.toInt();
  if (index >= 0 && index < _moods.length) {
    return Text(_formatDate(index), style: const TextStyle(fontSize: 12));
  }
  return const Text('');
},
                    ),
                  ),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getMoodData(),
                    isCurved: true,
                    color: Colors.purple,
                    barWidth: 3,
                    isStrokeCapRound: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _selectedTab == 0 ? Colors.orange.shade100 : Colors.purple.shade100,
      appBar: AppBar(
        title: const Text("Mood History", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _tabButton("Journal", 0),
              _tabButton("Trends", 1),
            ],
          ),
          Expanded(
            child: _selectedTab == 0 ? _buildJournalScreen() : _buildMoodTrends(),
          ),
        ],
      ),
    );
  }
}
