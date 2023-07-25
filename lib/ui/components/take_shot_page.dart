import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class TakeShotPage extends StatefulWidget {
  @override
  _TakeShotPageState createState() => _TakeShotPageState();
}

class _TakeShotPageState extends State<TakeShotPage> {
  CameraController? controller;
  @override
  void initState() {
    super.initState();
    availableCameras().then((value) {
      print(value);
      controller = CameraController(value.first, ResolutionPreset.high);
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: file == null
          ? FloatingActionButton(
              child: Icon(Icons.camera),
              onPressed: () async {
                var v = await controller!.takePicture();
                file = File(v.path);
                setState(() {});
              },
            )
          : null,
      backgroundColor: Colors.black,
      body: controller != null
          ? SafeArea(
              child: file != null
                  ? Column(
                      children: [
                        Expanded(child: Image.file(file!)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  file = null;
                                });
                              },
                              icon: Icon(Icons.close),
                              color: Colors.red,
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context, file);
                              },
                              icon: Icon(Icons.check),
                              color: Colors.white,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],
                    )
                  : Stack(
                      children: [
                        CameraPreview(
                          controller!,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () {
                              availableCameras().then((value) {
                                controller = CameraController(
                                    controller!.description.name == '0'
                                        ? value[1]
                                        : value[0],
                                    ResolutionPreset.high);
                                controller!.initialize().then((_) {
                                  if (!mounted) {
                                    return;
                                  }
                                  setState(() {});
                                });
                              });
                            },
                            icon: Icon(Icons.cameraswitch),
                          ),
                        ),
                      ],
                    ),
            )
          : SizedBox(),
    );
  }
}
