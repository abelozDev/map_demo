# map_demo

Flutter demo application that demonstrates working with an interactive map.

## What it does

- Full-screen map via [MapLibre](https://maplibre.org/) ([maplibre](https://pub.dev/packages/maplibre) package).
- Raster base layer (Google Satellite) added in `onStyleLoaded`; camera set in `onMapCreated`.
- Toggle 2D/3D (map pitch) with the button on the right.

## Requirements

- Flutter SDK (see [pubspec.yaml](pubspec.yaml) for SDK constraint).
- Android (tested on Android; other platforms may work depending on MapLibre support).

## Run

```bash
flutter pub get
flutter run
```

## Project structure

- `lib/main.dart` — one screen with `MapLibreMap`, 2D/3D toggle overlay.

## Links

- [Flutter documentation](https://docs.flutter.dev/)
- [MapLibre Flutter documentation](https://flutter-maplibre.pages.dev/)
