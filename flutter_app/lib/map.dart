import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:ourweather/addSimplePointModal.dart';
import 'package:ourweather/searchModal.dart';
import 'package:location/location.dart' as loc;

class MapboxScreen extends StatefulWidget {
  const MapboxScreen({super.key});

  @override
  State<MapboxScreen> createState() => _MapboxScreenState();
}

class _MapboxScreenState extends State<MapboxScreen> {
  MapboxMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
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

  void _centerMapOnPlace(LatLng coordinates) {
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: coordinates,
        zoom: 14.0,
      ),
    ));
  }

  Future<void> _showSearchModal(BuildContext context) async {
    final selectedPlace = await showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Permet au contenu de dépasser la moitié de l'écran
      builder: (BuildContext context) {
        return const SearchModal();
      },
    );
    selectedPlace != null
        ? _centerMapOnPlace(LatLng(selectedPlace.geometry!.coordinates![1],
            selectedPlace.geometry!.coordinates![0]))
        : null;
  }

  Future<void> _showAddModal(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Permet au contenu de dépasser la moitié de l'écran
      builder: (BuildContext context) {
        return const AddSimplePointModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapboxMap(
          onMapCreated: (controller) {
            _mapController = controller;
          },
          accessToken:
              'sk.eyJ1IjoiY2xlbWciLCJhIjoiY2xsdzFrM3ptMWh0cDNkbzd5eWdmZTJ5dSJ9.Nv3akDqWtOADauEl_YyFFw',
          initialCameraPosition: const CameraPosition(
            target: LatLng(0, 0),
            zoom: 14,
          ),
          myLocationEnabled: true),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _showAddModal(context);
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              _showSearchModal(context);
            },
            child: const Icon(Icons.search),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              _getUserLocation();
            },
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }
}
