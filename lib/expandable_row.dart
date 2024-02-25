import 'package:flutter/material.dart';

class ExpandableRow extends StatefulWidget {
  final String title;
  final String shortText;
  final String author;
  final VoidCallback onViewArchivePressed;
  final bool isExpanded;
  final VoidCallback onViewExpansionChanged;

  const ExpandableRow(
      {super.key,
      required this.title,
      required this.shortText,
      required this.author,
      required this.onViewArchivePressed,
      required this.isExpanded,
      required this.onViewExpansionChanged});

  @override
  // ignore: library_private_types_in_public_api
  _ExpandableRowState createState() {
    return _ExpandableRowState();
  }
}

class _ExpandableRowState extends State<ExpandableRow> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ListTile(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () {
          setState(() {
            widget.onViewExpansionChanged();
          });
        },
        trailing: widget.isExpanded
            ? const Icon(Icons.expand_less)
            : const Icon(Icons.expand_more),
      ),
      AnimatedContainer(
          duration: const Duration(milliseconds: 5000),
          curve: Curves.easeInOut,
          height: widget.isExpanded ? null : 0,
          child: widget.isExpanded
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Author: ${widget.author}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.shortText,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                            onPressed: widget.onViewArchivePressed,
                            child: const Text('View Archive')),
                      ]))
              : null)
    ]);
  }
}
