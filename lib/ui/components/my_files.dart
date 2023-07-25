import 'dart:io';

import 'package:bind_app/ui/theme/app_colors.dart';
import 'package:bind_app/utils/labels.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'take_shot_page.dart';

class MyImages {
  static Future<File?> pickAndCrop() async {
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file != null) {
        if (File(file.path).readAsBytesSync().lengthInBytes / (1024 * 1024) >
            4) {
          Fluttertoast.showToast(msg: Labels.maxUploadSize4mb);
          return null;
        }
        return await crop(file.path);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

    static Future<File?> pickAndCompress() async {
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file != null) {
        if (File(file.path).readAsBytesSync().lengthInBytes / (1024 * 1024) >
            4) {
          Fluttertoast.showToast(msg: Labels.maxUploadSize4mb);
          return null;
        }
        return await compress(file.path);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<File?> crop(String path) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      maxHeight: 512,
      maxWidth: 512,
      sourcePath: path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: AppColors.textColor,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
          backgroundColor: AppColors.backgroundColor,
          dimmedLayerColor: AppColors.backgroundColor.withOpacity(0.5),
        ),
        IOSUiSettings(),
      ],
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }

  static Future<File?> compress(String path) async {
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(path);
    File compressedFile = await FlutterNativeImage.compressImage(path,
        quality: 100,
        targetWidth: 1000,
        targetHeight:
            ((properties.height ?? 1) * 1000 / (properties.width ?? 1))
                .round());
        print("compressed: ${compressedFile.readAsBytesSync().lengthInBytes / (1024 * 1024)}");
    return compressedFile;
  }

  static Future<String?> showSources(BuildContext context) async {
    return await showModalBottomSheet<String?>(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      )),
      context: context,
      builder: (context) => Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 48),
            child: Row(
              children: [
                if (defaultTargetPlatform == TargetPlatform.iOS)
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: SizedBox(
                            height: 56,
                            width: 56,
                            child: RawMaterialButton(
                              fillColor: AppColors.primary,
                              shape: CircleBorder(),
                              onPressed: () {
                                Navigator.pop(context, 'photo');
                              },
                              child: Icon(Icons.image),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text('Photos'),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: SizedBox(
                          height: 56,
                          width: 56,
                          child: RawMaterialButton(
                            fillColor: AppColors.primary,
                            shape: CircleBorder(),
                            onPressed: () {
                              Navigator.pop(context, 'file');
                            },
                            child: Icon(Icons.folder),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text('File Explorer'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: SizedBox(
                          height: 56,
                          width: 56,
                          child: RawMaterialButton(
                            fillColor: AppColors.primary,
                            shape: CircleBorder(),
                            onPressed: () {
                              Navigator.pop(context, 'camera');
                            },
                            child: Icon(Icons.photo_camera),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text('Camera'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            child: CloseButton(),
            right: 8,
            top: 8,
          )
        ],
      ),
    );
  }

  static Future<File?> takeShot(BuildContext context) async {
    File? file;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        file = File(pickedFile.path);
      }
    } else {
      file = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TakeShotPage(),
        ),
      );
    }
    return file != null ? await compress(file.path) : null;
  }

  static Future<File?> pickDocument(BuildContext context) async {
    String? value;
    File? file;
    value = await MyImages.showSources(context);

    if (value == "photo") {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        file = await compress(picked.path);
      }
    } else if (value == "file") {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'png'],
      );
      if (result != null) {
        File _file = File(result.files.single.path!);
        if (_file.path.endsWith('.jpg') || _file.path.endsWith('.png')) {
          file = await compress(_file.path);
        } else {
          file = _file;
        }
      }
    } else if (value == "camera") {
      file = await takeShot(context);
    }
    if (file != null) {
      if (file.readAsBytesSync().lengthInBytes / (1024 * 1024) > 4) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Labels.maxUploadSize4mb),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        return file;
      }
    }
    return null;
  }
}
