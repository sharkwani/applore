import 'dart:io';

import 'package:demoapplication/providers/ScreenArguments.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

typedef void ImageFileCallback(File val);

class ImageCaptureForShop extends StatefulWidget {
  static const routeName = '/imageCapture';

  //final String shopId;

  //String productName;
  //ImageCaptureForShop(this.shopId, {this.productName});
  @override
  _ImageCaptureForShopState createState() => _ImageCaptureForShopState();
}

class _ImageCaptureForShopState extends State<ImageCaptureForShop> {
  File _imageFile;
  int size;
  final picker = ImagePicker();

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        // ratioX: 1.0,
        // ratioY: 1.0,
        // maxWidth: 512,
        // maxHeight: 512,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    var uuid = Uuid();

// Generate a v1 (time-based) id

    final pickedFile =
        await picker.getImage(source: source, maxHeight: 800, maxWidth: 800);
    print(File(pickedFile.path).absolute.path);
    var result = await FlutterImageCompress.compressAndGetFile(
      File(pickedFile.path).absolute.path,
      "/storage/emulated/0/Android/data/com.example.demoapplication/files/Pictures/${uuid.v1()}.jpg",
      quality: 88,
    );
    setState(() {
      try {
        _imageFile = result;
        size = File(pickedFile.path).lengthSync();
        print(_imageFile.lengthSync());
      } catch (error) {
        print("00no error");
      }
    });
  }

  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      // Select an image from the camera or gallery
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            FlatButton(
              child: Text("Camera"),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            SizedBox(
              width: 12,
            ),
            FlatButton(
              child: Text("Gallery"),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),

      // Preview the image and crop it
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            Image.file(_imageFile),
            Row(
              children: <Widget>[
                FlatButton(
                  child: Text("Crop"),
                  onPressed: _cropImage,
                ),
                FlatButton(
                  child: Text("Refresh"),
                  onPressed: _clear,
                ),
              ],
            ),
            Uploader(
                file: _imageFile, productName: args.productName, size: size)
          ]
        ],
      ),
    );
  }
}

class Uploader extends StatefulWidget {
  final File file;
  final int size;
  final String productName;

  const Uploader({Key key, this.file, this.productName, this.size})
      : super(key: key);
  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  popof() {
    print("am in popof");

    Navigator.pop(context, ImageCaptureReturnedValues(widget.file));
  }

  @override
  Widget build(BuildContext context) {
    // Allows user to decide when to start the upload
    return Column(
      children: [
        FlatButton(
          child: Text('Done'),
          onPressed: popof,
        ),
        // Progress bar

        Text(' Compressed Image Size : ${filesize(widget.file.lengthSync())}'),
        SizedBox(height: 10),
        Text(' Original Image Size : ${filesize(widget.size)}'),
      ],
    );
  }
}

class ImageCaptureReturnedValues {
  final File file;

  ImageCaptureReturnedValues(this.file);
}
