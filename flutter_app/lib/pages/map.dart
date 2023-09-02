import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:planus/components/searchModal.dart';

class MapboxScreen extends StatefulWidget {
  const MapboxScreen({super.key});

  @override
  State<MapboxScreen> createState() => _MapboxScreenState();
}

class _MapboxScreenState extends State<MapboxScreen> {
  MapboxMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapboxMap(
              onMapCreated: (controller) {
                _mapController = controller;
                setState(() {});
              },
              accessToken:
                  'sk.eyJ1IjoiY2xlbWciLCJhIjoiY2xsdzFrM3ptMWh0cDNkbzd5eWdmZTJ5dSJ9.Nv3akDqWtOADauEl_YyFFw',
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0),
                zoom: 14,
              ),
              myLocationEnabled: true),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.25,
            right: 0,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    width: 75.0,
                    height: 75.0,
                    decoration: ShapeDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.00, -1.00),
                        end: Alignment(0, 1),
                        colors: [Color(0xFF00147B), Color(0xFF1248B1)],
                      ),
                      shape: OvalBorder(
                        side: BorderSide(width: 4, color: Colors.white),
                      ),
                    ),
                  ),
                )),
          ),
          SearchModal(
            controller: _mapController,
          ),
        ],
      ),
    );
  }
}
