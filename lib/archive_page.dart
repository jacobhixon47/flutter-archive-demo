import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'report_row.dart';

class ArchivePage extends StatefulWidget {
  final String id;
  final String name;

  const ArchivePage({super.key, required this.id, required this.name});

  @override
  // ignore: library_private_types_in_public_api
  _ArchivePageState createState() {
    return _ArchivePageState();
  }
}

class _ArchivePageState extends State<ArchivePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text(widget.name), backgroundColor: Colors.black26),
        body: Query(
          options: QueryOptions(document: gql('''
            query GetReports(\$id: ID!){
              reports(where: { collection: { id: \$id } }) {
                id
                city
                state
                country
                description
                date
              }
            }
          '''), variables: {'id': widget.id}),
          builder: (QueryResult result,
              {FetchMore? fetchMore, Refetch? refetch}) {
            if (result.hasException) {
              return Text('Error: ${result.exception.toString()}');
            }

            if (result.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            final reports = result.data!['reports'];
            bool isAscending = false;
            void toggleSortingOrder() {
              isAscending = !isAscending;
              debugPrint(isAscending.toString());
            }

            reports.sort((a, b) {
              DateTime dateA = DateTime.parse(a['date']);
              DateTime dateB = DateTime.parse(b['date']);
              // Compare dates based on the sorting order
              return isAscending
                  ? dateA.compareTo(dateB)
                  : dateB.compareTo(dateA);
            });
            return Column(
              children: [
                // ElevatedButton(
                //     onPressed: toggleSortingOrder,
                //     child: Text(isAscending ? 'Asc' : 'Desc')),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    return ReportRow(
                        id: report['id'],
                        index: index,
                        archiveName: widget.name,
                        city: report['city'],
                        state: report['state'],
                        country: report['country'],
                        description: report['description'],
                        date: report['date']);
                  },
                ),
              ],
            );
          },
        ));
  }
}
