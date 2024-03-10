import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportPage extends StatelessWidget {
  final String id;
  final int index;
  final String archiveName;
  final String city;
  final String state;
  final String country;
  final String description;
  final String date;
  final DateFormat dateFormat;

  const ReportPage(
      {super.key,
      required this.id,
      required this.index,
      required this.archiveName,
      required this.city,
      required this.state,
      required this.country,
      required this.description,
      required this.date,
      required this.dateFormat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text(archiveName), backgroundColor: Colors.black26),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Report #${index + 1}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25)),
                // Text('ID: $id',
                //     style: const TextStyle(fontStyle: FontStyle.italic)),
                const SizedBox(height: 20),
                // Text('Location: $city, $state'),
                RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                      text: 'Location: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '$city, $state')
                ])),
                RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                      text: 'Country: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: country)
                ])),
                RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                      text: 'Date: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: dateFormat.format(DateTime.parse(date)))
                ])),
                const SizedBox(height: 20),
                const Text('Description:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(description)
              ],
            ),
          ),
        ));
  }
}
