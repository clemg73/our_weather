import 'package:flutter/material.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/services.dart'; // N'oubliez pas cette importation

class SearchModal extends StatefulWidget {
  final MapboxMapController? controller;
  const SearchModal({super.key, this.controller});

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  final _searchController = TextEditingController();
  Future<List<MapBoxPlace>?>? _placesFuture;
  DraggableScrollableController modalController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  var placesSearch = PlacesSearch(
    apiKey:
        'sk.eyJ1IjoiY2xlbWciLCJhIjoiY2xsdzFrM3ptMWh0cDNkbzd5eWdmZTJ5dSJ9.Nv3akDqWtOADauEl_YyFFw',
    limit: 5,
  );

  void _centerMapOnPlace(LatLng coordinates) {
    widget.controller?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: coordinates,
        zoom: 14.0,
      ),
    ));
  }

  Future<void> _getUserLocation() async {
    final location = loc.Location();
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    loc.LocationData currentLocation = await location.getLocation();
    _centerMapOnPlace(
        LatLng(currentLocation.latitude!, currentLocation.longitude!));
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    return DraggableScrollableSheet(
      controller: modalController,
      snap: true,
      initialChildSize: 0.25,
      minChildSize: 0.25,
      snapSizes: const [0.25, 0.9],
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: CustomScrollView(controller: scrollController, slivers: [
            SliverFillRemaining(
              hasScrollBody: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 56,
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(243, 243, 243, 1),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.location_on),
                                ),
                                Expanded(
                                  child: TextField(
                                    onTap: () {
                                      modalController.animateTo(0.9,
                                          duration: Duration(milliseconds: 100),
                                          curve: Curves.bounceIn);
                                    },
                                    onChanged: (value) async {
                                      final places =
                                          await placesSearch.getPlaces(value);
                                      setState(() {
                                        _placesFuture = Future.value(places);
                                      });
                                    },
                                    controller: _searchController,
                                    decoration: const InputDecoration(
                                      hintText: 'Rechercher',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              height: 56,
                              width: 56,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(243, 243, 243, 1),
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: ElevatedButton(
                                  onPressed: () {
                                    // Action à effectuer lorsque le bouton est pressé
                                  },
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(0),
                                    backgroundColor: MaterialStateProperty.all(
                                        Color.fromRGBO(243, 243, 243,
                                            1)), // Couleur de fond grise

                                    padding: MaterialStateProperty.all(
                                        EdgeInsets
                                            .zero), // Supprimer le padding
                                  ),
                                  child: Center(
                                      child: Icon(
                                    Icons.my_location,
                                    color: Colors.black,
                                  )))),
                        ],
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<List<MapBoxPlace>?>(
                        future: _placesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data == null) {
                            return const Text("");
                          } else {
                            final places = snapshot.data;
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: places!.length,
                              itemBuilder: (context, index) {
                                final place = places[index];
                                return ListTile(
                                  title: Text(place.text.toString()),
                                  subtitle: Text(place.placeName ?? ''),
                                  onTap: () {
                                    currentFocus.unfocus();
                                    modalController.animateTo(0.25,
                                        duration: Duration(milliseconds: 100),
                                        curve: Curves.bounceIn);
                                    _centerMapOnPlace(LatLng(
                                        place.geometry!.coordinates![1],
                                        place.geometry!.coordinates![0]));
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
              ),
            )
          ]),
        );
      },
    );
  }
}
