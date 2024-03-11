import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'report_page.dart';

class ReportRow extends StatelessWidget {
  final String id;
  final int index;
  final String archiveName;
  final String city;
  final String state;
  final String country;
  final String description;
  final String date;
  final DateFormat dateFormat = DateFormat("MM/dd/yyyy");

  ReportRow(
      {super.key,
      required this.id,
      required this.index,
      required this.archiveName,
      required this.city,
      required this.state,
      required this.country,
      required this.description,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            CupertinoPageRoute(
                fullscreenDialog: false,
                builder: (context) => ReportPage(
                      id: id,
                      index: index,
                      archiveName: archiveName,
                      city: city,
                      state: state,
                      country: country,
                      description: description,
                      date: date,
                      dateFormat: DateFormat('MMMM dd, yyyy'),
                    )))
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: const BorderRadius.all(Radius.elliptical(5, 5))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('#${index + 1}'),
            Text('$city, $state'),
            Text(dateFormat.format(DateTime.parse(date)))
          ],
        ),
      ),
    );
  }
}
