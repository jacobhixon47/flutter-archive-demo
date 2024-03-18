import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'report_row.dart';

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
  bool _isFetchingData = false; // To keep track of data fetching state.

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // To prevent fetching data multiple times if dependencies change, check if data has already been fetched.
    if (!_isFetchingData) {
      _isFetchingData = true; // Prevents multiple fetches.
      fetchAllReports();
    }
  }

  Future<void> fetchAllReports() async {
    // Assuming this GraphQL query fetches all needed fields.
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
        _isFetchingData = false; // Data fetching is complete.
      });
    } else {
      print('Error fetching reports: ${result.exception.toString()}');
      setState(() => _isFetchingData = false);
    }
  }

  void clearFilters() {
    setState(() {
      selectedCountry = null;
      selectedState = null;
      selectedCity = null;
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
    }
    if (selectedState != null) {
      filteredReports = filteredReports
          .where((report) => report['state'] == selectedState)
          .toList();
    }
    if (selectedCity != null) {
      filteredReports = filteredReports
          .where((report) => report['city'] == selectedCity)
          .toList();
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.name), backgroundColor: Colors.black26),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                  items: countries.map<DropdownMenuItem<String>>((value) {
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
                    items: states.map<DropdownMenuItem<String>>((value) {
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
                    items: cities.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
          ElevatedButton(
              onPressed: clearFilters, child: const Text('Clear Filters')),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredReports.length,
              itemBuilder: (context, index) {
                final report = filteredReports[index];
                return ReportRow(
                  id: report['id'],
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
