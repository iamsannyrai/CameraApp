import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            final path = join(
                (await getTemporaryDirectory()).path, '${DateTime.now()}.png');

            final savedPath = await _controller.takePicture();

            print('savedPath.path: ${savedPath.path}');

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: savedPath.path),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}


class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}