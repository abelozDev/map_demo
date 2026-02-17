import 'package:flutter/material.dart';
import 'package:maplibre/maplibre.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _sourceId = 'google-satellite';
  static const _layerId = 'google-satellite-layer';

  static const _moscow = Geographic(lon: 37.618423, lat: 55.751244);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapLibreMap(
        onMapCreated: (controller) {
          controller.moveCamera(
            center: _moscow,
            zoom: 10,
          );
        },
        onStyleLoaded: (style) async {
          const source = RasterSource(
            id: _sourceId,
            tiles: [
              'http://mt0.google.com/vt/lyrs=y&x={x}&y={y}&z={z}',
            ],
            maxZoom: 22,
            tileSize: 256,
          );
          await style.addSource(source);
          const layer = RasterStyleLayer(
            id: _layerId,
            sourceId: _sourceId,
          );
          await style.addLayer(layer);
        },
      ),
    );
  }
}
