import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ArchivePage extends StatelessWidget {
  final String id;
  final String name;

  const ArchivePage({super.key, required this.id, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(name), backgroundColor: Colors.black26),
        body: Query(
          options: QueryOptions(document: gql('''
            query GetReports(\$id: ID!){
              reports(where: { collection: { id: \$id } }) {
                id
                city
                state
                country
                description
              }
            }
          '''), variables: {'id': id}),
          builder: (QueryResult result,
              {FetchMore? fetchMore, Refetch? refetch}) {
            if (result.hasException) {
              return Text('Error: ${result.exception.toString()}');
            }

            if (result.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            final reports = result.data!['reports'];
            return ListView.builder(
              shrinkWrap: true,
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return Text(report['city']);
              },
            );
          },
        ));
  }
}
