import 'package:flutter/material.dart';

class ManualControlsWidget extends StatelessWidget {
  final Function(String) onSendCommand;

  const ManualControlsWidget({Key? key, required this.onSendCommand})
      : super(key: key);

  Widget _buildControlButton(IconData icon, String command, Color color) {
    return GestureDetector(
      onTapDown: (_) => onSendCommand(command), // Command sent on button press
      onTapUp: (_) => onSendCommand('/stop'),  // Stop command on button release
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(2, 2),
              blurRadius: 6,
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            offset: const Offset(4, 4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-4, -4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Manual Controls",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          _buildControlButton(Icons.arrow_upward, '/forward', Colors.grey),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(Icons.arrow_back, '/left', Colors.grey),
              _buildControlButton(Icons.arrow_forward, '/right', Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
          _buildControlButton(Icons.arrow_downward, '/reverse', Colors.grey),
        ],
      ),
    );
  }
}
