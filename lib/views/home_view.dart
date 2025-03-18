import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Initialize Google Maps Controller
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; // Map to store markers

  // Set initial camera position
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.033333, 31.53700030),
    zoom: 14.4746,
  );

  // Set Cairo location
  static const CameraPosition _kCairo = CameraPosition(
    target: LatLng(30.033333, 31.23700030),
    zoom: 12.351926040649414,
  );

  // Set the map controller with adding a marker
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    final marker = Marker(
      markerId: MarkerId('Cairo'),
      position: LatLng(30.033333, 31.23700030),
    );

    setState(() {
      markers[MarkerId('Cairo')] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map'),
        centerTitle: true,
      ),
      // Set the map
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: _onMapCreated,
        markers: markers.values.toSet(), // Set the marker
      ),
      // Set the floating button to go to Cairo
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCairo,
        label: const Text('To Cairo!'),
        icon: const Icon(Icons.place_outlined),
      ),
    );
  }

  // Function to go to Cairo
  Future<void> _goToCairo() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kCairo));
  }
}
