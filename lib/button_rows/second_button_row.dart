import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class SecondButtonRow extends StatelessWidget {
  const SecondButtonRow({super.key});

  void _showCircularSliderModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double circularSliderValue = 0; // Default or initial value
        return AlertDialog(
          title: const Text("Credibility", textAlign: TextAlign.center),
          alignment: Alignment.center,
          content: SizedBox(
            height: 200,
            width: double.infinity, // Adjust based on your UI needs
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SleekCircularSlider(
                  initialValue: circularSliderValue,
                  appearance: CircularSliderAppearance(
                    customWidths: CustomSliderWidths(
                      trackWidth: 10, // Adjust the track width
                      progressBarWidth: 20, // Adjust the progress bar width
                    ),
                    customColors: CustomSliderColors(
                        trackColor: Colors.white30,
                        // progressBarColors: [
                        //   Colors.greenAccent,
                        //   Colors.blue,
                        // ],
                        // dotColor: Colors.transparent,
                        progressBarColor: Colors.greenAccent,
                        dotColor: Colors.transparent,
                        hideShadow: true),
                    infoProperties: InfoProperties(
                      mainLabelStyle: const TextStyle(
                        color: Colors.white70, // Color of the main label text
                        fontSize: 30, // Font size of the main label text
                      ),
                      // Optionally, adjust modifier to customize the display of the value.
                      modifier: (double value) {
                        final roundedValue = value.toStringAsFixed(0);
                        return '$roundedValue%'; // Example modifier
                      },
                    ),
                  ),
                  min: 0,
                  max: 100,
                  onChange: (double value) {
                    circularSliderValue = value;
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                    'Note: Credibility submission cannot be changed after clicking "Confirm".',
                    style: TextStyle(fontStyle: FontStyle.italic))
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Here, you might want to do something with the selected value,
                // like updating a state or storing it.
                debugPrint('Selected value: $circularSliderValue');
              },
            ),
          ],
          contentPadding:
              const EdgeInsets.all(16), // Adjust based on your UI needs
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () => debugPrint('Liked'),
              icon: const Icon(Icons.favorite_border)),
          IconButton(
              onPressed: () => _showCircularSliderModal(context),
              icon: const Icon(Icons.workspace_premium_outlined)),
          IconButton(
              onPressed: () => debugPrint('Reply'),
              icon: const Icon(Icons.message_outlined)),
        ],
      ),
    );
  }
}
