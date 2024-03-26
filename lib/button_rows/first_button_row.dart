import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class FirstButtonRow extends StatefulWidget {
  const FirstButtonRow({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FirstButtonRowState createState() => _FirstButtonRowState();
}

class _FirstButtonRowState extends State<FirstButtonRow> {
  bool _isSliderVisible = false;
  double _sliderValue = 0;

  void _toggleSlider() {
    setState(() {
      _isSliderVisible = !_isSliderVisible;
      !_isSliderVisible ? _sliderValue = 0 : null;
    });
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm Submission',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Credibility Rating: ${_sliderValue.toInt()}%',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center),
              const SizedBox(height: 15),
              const Text(
                'Note: This cannot be changed after submission.',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              )
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: <Widget>[
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
                _toggleSlider(); // Reset to original state
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: _isSliderVisible
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: _toggleSlider,
                    ),
                    Expanded(
                      child: FlutterSlider(
                        values: [_sliderValue],
                        max: 100,
                        min: 0,
                        trackBar: const FlutterSliderTrackBar(
                          activeTrackBarHeight: 5,
                          inactiveTrackBarHeight: 5,
                          activeTrackBar:
                              BoxDecoration(color: Colors.greenAccent),
                          inactiveTrackBar:
                              BoxDecoration(color: Colors.white30),
                        ),
                        tooltip: FlutterSliderTooltip(disabled: true),
                        handler: FlutterSliderHandler(
                            decoration: const BoxDecoration(),
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                            )),
                        onDragging: (handlerIndex, lowerValue, upperValue) {
                          setState(() {
                            _sliderValue = lowerValue.round().toDouble();
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check_rounded),
                      onPressed: () {
                        _showConfirmationDialog();
                      },
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () => debugPrint('Liked'),
                        icon: const Icon(Icons.favorite_border)),
                    IconButton(
                        onPressed: _toggleSlider,
                        icon: const Icon(Icons.workspace_premium_outlined)),
                    IconButton(
                        onPressed: () => debugPrint('Reply'),
                        icon: const Icon(Icons.message_outlined)),
                  ],
                ),
        ),
        if (_isSliderVisible) Text('Credibility: ${_sliderValue.toInt()}%'),
      ],
    );
  }
}
