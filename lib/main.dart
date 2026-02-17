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
  static const _rasterLayerVisible = RasterStyleLayer(
    id: _layerId,
    sourceId: _sourceId,
    layout: {'visibility': 'visible'},
  );
  static const _moscow = Geographic(lon: 37.618423, lat: 55.751244);
  static const _pitch3D = 50.0;

  MapController? _mapController;
  bool _is3D = false;
  bool _isSatellite = true;

  void _toggle2D3D() {
    final c = _mapController;
    if (c == null) return;
    setState(() => _is3D = !_is3D);
    final camera = c.getCamera();
    c.moveCamera(
      center: camera.center,
      zoom: camera.zoom,
      bearing: camera.bearing,
      pitch: _is3D ? _pitch3D : 0,
    );
  }

  void _zoomIn() {
    final c = _mapController;
    if (c == null) return;
    final camera = c.getCamera();
    c.moveCamera(
      center: camera.center,
      zoom: (camera.zoom + 1).clamp(0.0, 22.0),
      bearing: camera.bearing,
      pitch: camera.pitch,
    );
  }

  void _zoomOut() {
    final c = _mapController;
    if (c == null) return;
    final camera = c.getCamera();
    c.moveCamera(
      center: camera.center,
      zoom: (camera.zoom - 1).clamp(0.0, 22.0),
      bearing: camera.bearing,
      pitch: camera.pitch,
    );
  }

  void _toggleSchemeSatellite() {
    final style = _mapController?.style;
    if (style == null) return;
    setState(() => _isSatellite = !_isSatellite);
    if (_isSatellite) {
      style.addLayer(_rasterLayerVisible);
    } else {
      style.removeLayer(_layerId);
    }
  }

  Widget _buildButton(dynamic content, {VoidCallback? onTap}) {
    final isIcon = content is IconData;
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: isIcon
              ? Icon(content as IconData, size: 24, color: Colors.black87)
              : Text(
                  content as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    return Scaffold(
      body: Stack(
        children: [
          MapLibreMap(
            onMapCreated: (controller) {
              _mapController = controller;
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
              await style.addLayer(_rasterLayerVisible);
            },
          ),
          Positioned(
            right: 20,
            top: 0,
            bottom: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildButton(_is3D ? '3D' : '2D', onTap: _toggle2D3D),
                  const SizedBox(height: 10),
                  _buildButton(Icons.add, onTap: _zoomIn),
                  const SizedBox(height: 10),
                  _buildButton(Icons.remove, onTap: _zoomOut),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: padding.bottom + 20,
            child: _buildButton(
              _isSatellite ? 'Спутник' : 'Схема',
              onTap: () => _toggleSchemeSatellite(),
            ),
          ),
        ],
      ),
    );
  }
}
