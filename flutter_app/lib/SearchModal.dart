import 'package:flutter/material.dart';
import 'package:mapbox_search/mapbox_search.dart';

class SearchModal extends StatefulWidget {
  const SearchModal({super.key});

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  final _searchController = TextEditingController();
  Future<List<MapBoxPlace>?>? _placesFuture;

  var placesSearch = PlacesSearch(
    apiKey:
        'sk.eyJ1IjoiY2xlbWciLCJhIjoiY2xsdzFrM3ptMWh0cDNkbzd5eWdmZTJ5dSJ9.Nv3akDqWtOADauEl_YyFFw',
    limit: 5,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Enter a search term',
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    final places =
                        await placesSearch.getPlaces(_searchController.text);
                    setState(() {
                      _placesFuture = Future.value(places);
                    });
                  },
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<MapBoxPlace>?>(
              future: _placesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Text('No places found.');
                } else {
                  final places = snapshot.data;
                  return ListView.builder(
                    itemCount: places!.length,
                    itemBuilder: (context, index) {
                      final place = places[index];
                      return ListTile(
                        title: Text(place.text.toString()),
                        subtitle: Text(place.placeName ?? ''),
                        onTap: () {
                          Navigator.of(context).pop(place);
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
