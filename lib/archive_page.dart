import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'report_row.dart';
import 'dart:math';

class ArchivePage extends StatefulWidget {
  final String id;
  final String name;

  const ArchivePage({super.key, required this.id, required this.name});

  @override
  // ignore: library_private_types_in_public_api
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  List<Map<String, dynamic>> allReports = [];
  List<String> countries = [];
  List<String> states = [];
  List<String> cities = [];
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  bool _isFetchingData = false;
  bool _areFiltersVisible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Prevents fetching data multiple times if dependencies change, checks if data has already been fetched.
    if (!_isFetchingData) {
      // Prevents multiple fetches.
      _isFetchingData = true;
      fetchAllReports();
      debugPrint('\x1B[36m ARCHIVE SELECTED --->');
      debugPrint('\x1B[33m FETCHING DATA --->');
    }
  }

  void filterVisibilityChanged() {
    setState(() {
      _areFiltersVisible = !_areFiltersVisible;
    });
  }

  Future<void> fetchAllReports() async {
    const String fetchReportsQuery = '''
      query FetchReports(\$id: ID!) {
        reports(where: { collection: { id: \$id } }) {
          id
          country
          state
          city
          description
          date
        }
      }
    ''';

    final GraphQLClient client = GraphQLProvider.of(context).value;
    final QueryResult result = await client.query(
      QueryOptions(
          document: gql(fetchReportsQuery), variables: {'id': widget.id}),
    );

    if (!result.hasException) {
      setState(() {
        allReports = List<Map<String, dynamic>>.from(result.data!['reports']);
        countries = allReports
            .map((report) => report['country'] as String)
            .toSet()
            .toList();
        _isFetchingData = false;
        debugPrint(
            '\x1B[32m DATA FETCHING COMPLETE --->'); // Data fetching is complete.
      });
    } else {
      debugPrint(
          '\x1B[31mError fetching reports: ${result.exception.toString()}');
      setState(() => _isFetchingData = false);
    }
  }

  void clearFilters() {
    setState(() {
      selectedCountry = null;
      selectedState = null;
      selectedCity = null;
      debugPrint('\x1B[32m FILTERS CLEARED --->');
    });
  }

  List<String> filterStates(String country) {
    return allReports
        .where((report) => report['country'] == country)
        .map((report) => report['state'] as String)
        .toSet()
        .toList();
  }

  List<String> filterCities(String state) {
    return allReports
        .where((report) => report['state'] == state)
        .map((report) => report['city'] as String)
        .toSet()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    states = selectedCountry != null ? filterStates(selectedCountry!) : [];
    cities = selectedState != null ? filterCities(selectedState!) : [];

    List<Map<String, dynamic>> filteredReports = allReports;
    if (selectedCountry != null) {
      filteredReports = filteredReports
          .where((report) => report['country'] == selectedCountry)
          .toList();
      debugPrint('\x1B[37m COUNTRY SELECTED: $selectedCountry --->');
    }
    if (selectedState != null) {
      filteredReports = filteredReports
          .where((report) => report['state'] == selectedState)
          .toList();
      debugPrint('\x1B[37m STATE SELECTED: $selectedState --->');
    }
    if (selectedCity != null) {
      filteredReports = filteredReports
          .where((report) => report['city'] == selectedCity)
          .toList();
      debugPrint('\x1B[37m CITY SELECTED: $selectedCity --->');
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.name), backgroundColor: Colors.black26),
      body: Column(
        children: [
          ListTile(
            title: const Text('Filters'),
            onTap: filterVisibilityChanged,
            trailing: _areFiltersVisible
                ? const Icon(Icons.expand_less)
                : const Icon(Icons.expand_more),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            reverseDuration: const Duration(milliseconds: 0),
            child: Container(
              height: _areFiltersVisible ? null : 0,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: _areFiltersVisible
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButton<String>(
                              hint: const Text("Select Country"),
                              value: selectedCountry,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedCountry = newValue;
                                  selectedState = null;
                                  selectedCity = null;
                                });
                              },
                              items: countries
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            if (selectedCountry != null) // State Dropdown
                              DropdownButton<String>(
                                hint: const Text("Select State"),
                                value: selectedState,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedState = newValue;
                                    selectedCity = null;
                                  });
                                },
                                items: states
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            if (selectedState != null) // City Dropdown
                              DropdownButton<String>(
                                hint: const Text("Select City"),
                                value: selectedCity,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedCity = newValue;
                                  });
                                },
                                items: cities
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white70),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.indigo)),
                                  onPressed: clearFilters,
                                  child: const Text('Clear Filters')),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white70),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.indigo)),
                                  onPressed: filterVisibilityChanged,
                                  child: const Text('Apply Filters')),
                            ]),
                        const SizedBox(height: 10),
                      ],
                    )
                  : null,
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: filteredReports.length,
              itemBuilder: (context, index) {
                final report = filteredReports[index];
                return ReportRow(
                  id: '${Random().nextInt(90000) + 10000}',
                  index: index,
                  archiveName: widget.name,
                  city: report['city'],
                  state: report['state'],
                  country: report['country'],
                  description: report['description'],
                  date: report['date'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
