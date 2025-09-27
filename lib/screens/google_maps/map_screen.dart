import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentLatLng;
  final Set<Marker> _markers = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  /// Get current device location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location services are disabled.")),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLatLng = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: const MarkerId("current"),
          position: _currentLatLng!,
          infoWindow: const InfoWindow(title: "My Location"),
        ),
      );
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_currentLatLng!, 14),
    );
  }

  /// Search a place by name (replace old marker, keep current location)
  Future<void> _searchPlace(String query) async {
    if (query.isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final target = LatLng(locations[0].latitude, locations[0].longitude);

        setState(() {
          // Keep current location marker if exists
          final currentMarker = _markers.firstWhere(
            (m) => m.markerId.value == "current",
            orElse: () => const Marker(markerId: MarkerId("none")),
          );

          _markers.clear();

          if (currentMarker.markerId.value == "current") {
            _markers.add(currentMarker);
          }

          // Add new searched marker
          _markers.add(
            Marker(
              markerId: const MarkerId("searched"),
              position: target,
              infoWindow: InfoWindow(title: query),
            ),
          );
        });

        _mapController?.animateCamera(CameraUpdate.newLatLngZoom(target, 14));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Place not found")));
    }
  }

  /// Add marker when user taps on map (replace old marker, keep current location)
  void _onMapTapped(LatLng position) {
    setState(() {
      // Keep current location marker if exists
      final currentMarker = _markers.firstWhere(
        (m) => m.markerId.value == "current",
        orElse: () => const Marker(markerId: MarkerId("none")),
      );

      _markers.clear();

      if (currentMarker.markerId.value == "current") {
        _markers.add(currentMarker);
      }

      // Add tapped marker
      _markers.add(
        Marker(
          markerId: const MarkerId("selected"),
          position: position,
          infoWindow: const InfoWindow(title: "Selected Location"),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Maps Demo")),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: const CameraPosition(
              target: LatLng(30.0444, 31.2357), // Cairo default
              zoom: 10,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: _markers,
            onTap: _onMapTapped,
          ),
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Card(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search place...",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => _searchPlace(_searchController.text),
                  ),
                ),
                onSubmitted: _searchPlace,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
