import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

Future<void> main() async {
  // Ensures that plugin services are initialized before 'runApp()'
  WidgetsFlutterBinding.ensureInitialized();

  // lists all the available cameras
  final cameras = await availableCameras();
  debugPrint('list of camera: $cameras');

  // picks up the first one
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: CameraApp(camera: firstCamera),
    ),
  );
}

class CameraApp extends StatefulWidget {
  final CameraDescription camera;

  const CameraApp({@required this.camera});

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
