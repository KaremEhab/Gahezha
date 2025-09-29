import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class AppState {
  static LatLng? selectedLocation;
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng? _currentLatLng;
  LatLng? _selectedLatLng;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkGpsAndGetLocation();
  }

  /// Check if GPS is enabled & get current location
  Future<void> _checkGpsAndGetLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLatLng = LatLng(pos.latitude, pos.longitude);
      _selectedLatLng = _currentLatLng;
      AppState.selectedLocation = _selectedLatLng; // save globally
    });

    _mapController.move(_currentLatLng!, 15);
  }

  /// Search location by name / shop name
  Future<void> _searchPlace(String query) async {
    if (query.isEmpty) return;

    try {
      final locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final target = LatLng(locations[0].latitude, locations[0].longitude);

        setState(() {
          _selectedLatLng = target;
          AppState.selectedLocation = target; // save globally
        });

        _mapController.move(target, 15);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Place not found")));
    }
  }

  /// Handle tap on map
  void _onMapTap(TapPosition tapPosition, LatLng latlng) {
    setState(() {
      _selectedLatLng = latlng;
      AppState.selectedLocation = latlng; // save globally
    });
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[];

    if (_currentLatLng != null) {
      markers.add(
        Marker(
          point: _currentLatLng!,
          child: const Icon(Icons.my_location, color: Colors.blue, size: 30),
        ),
      );
    }

    if (_selectedLatLng != null) {
      markers.add(
        Marker(
          point: _selectedLatLng!,
          child: const Icon(Icons.location_on, color: Colors.red, size: 40),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Map Example")),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLatLng ?? const LatLng(30.0444, 31.2357),
              initialZoom: 10,
              onTap: _onMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=tTZD5GxTLfnXDww5bfTf",
                userAgentPackageName: "com.gahezha.gahezha",
                tileProvider:
                    NetworkTileProvider(), // makes sure PNGs load correctly
              ),
              MarkerLayer(markers: markers),
            ],
          ),
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Card(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search place or shop...",
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
        onPressed: _checkGpsAndGetLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
