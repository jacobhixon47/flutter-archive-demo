import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'expandable_row.dart';
import 'archive_page.dart';
import 'env/env.dart';

void main() {
  runApp(const MyApp());
}

final HttpLink httpLink = HttpLink(Env.apiLink);
final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
  GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(),
  ),
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: client,
        child: MaterialApp(
            title: 'GraphQL Demo',
            theme: ThemeData.dark(),
            home: Scaffold(
                appBar: AppBar(
                  title: const Text("Archives"),
                  backgroundColor: Colors.black26,
                ),
                body: Query(
                    options: QueryOptions(
                      document: gql('''
                        query Content{
                          collections{
                            id
                            name
                            author
                            description
                          }
                        }
                      '''),
                    ),
                    builder: (result, {fetchMore, refetch}) {
                      if (result.hasException) {
                        return Text('Error: ${result.exception.toString()}');
                      }

                      if (result.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (result.data == null) {
                        return const Center(
                            child: Text("No article found! Oopsie!"));
                      }

                      final List<dynamic> collections =
                          result.data!['collections'];
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: collections.length,
                          itemBuilder: (context, index) {
                            final collection = collections[index];
                            final bool isExpanded = index == _expandedIndex;
                            return Column(
                              children: [
                                ExpandableRow(
                                    id: collection['id'],
                                    title: collection['name'],
                                    shortText: collection['description'],
                                    author: collection['author'],
                                    onViewArchivePressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ArchivePage(
                                                  id: collection['id'],
                                                  name: collection['name'])));
                                    },
                                    isExpanded: isExpanded,
                                    onViewExpansionChanged: () {
                                      setState(() {
                                        _expandedIndex =
                                            isExpanded ? -1 : index;
                                      });
                                    }),
                              ],
                            );
                          });
                    }))));
  }
}
