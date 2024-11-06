import 'package:flutter/material.dart';

class DistanceCalculator {
  final TextEditingController distanceController = TextEditingController();


  int getTotalSeconds() {
    double distanceInMeters;
    try {
      distanceInMeters = double.parse(distanceController.text);
      return (distanceInMeters * 100).toInt(); // Convert distance to total seconds
    } catch (e) {
      return 0; // Return 0 if the input is invalid
    }
  }
  String getDistanceInCentimeters() {
    // Get the distance in meters from the controller
    double distanceInMeters;
    try {
      distanceInMeters = double.parse(distanceController.text);
      double distanceInCentimeters = distanceInMeters * 100; // Convert to cm
      return distanceInCentimeters.toStringAsFixed(0); // Return as a string
    } catch (e) {
      return 'Invalid input'; // Handle invalid input
    }
  }

  String getTimeNeeded() {
    // Get the distance in cm and calculate time
    String distanceInCmString = getDistanceInCentimeters();
    if (distanceInCmString == 'Invalid input') {
      return distanceInCmString;
    }
    int distanceInCm = int.parse(distanceInCmString);

    // Calculate time in seconds
    int totalSeconds = distanceInCm; // Time needed is equal to distance in cm

    // Convert seconds to hr:min:sec format
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    return '${hours}h ${minutes}m ${seconds}s'; // Return formatted string
  }

  void clearInput() {
    distanceController.clear(); // Clear the input field
  }

  List<String> getTimeIntervals() {
    int totalSeconds = getTotalSeconds();
    List<String> intervals = [];

    for (int i = 0; i <= totalSeconds; i += 15) { // 15 seconds interval
      int hours = i ~/ 3600;
      int minutes = (i % 3600) ~/ 60;
      int seconds = i % 60;
      intervals.add('${hours}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}');
    }

    return intervals;
  }

}
