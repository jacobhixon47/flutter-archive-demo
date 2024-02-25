import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'expandable_row.dart';
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

                      final List<dynamic> posts = result.data!['collections'];
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            final bool isExpanded = index == _expandedIndex;
                            return ExpandableRow(
                                title: post['name'],
                                shortText: post['description'],
                                author: post['author'],
                                onViewArchivePressed: () {},
                                isExpanded: isExpanded,
                                onViewExpansionChanged: () {
                                  setState(() {
                                    _expandedIndex = isExpanded ? -1 : index;
                                  });
                                });
                          });
                    }))));
  }
}
