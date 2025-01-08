import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:face_recognition_with_images/ML/recognition.dart';
import 'package:face_recognition_with_images/ML/recognizer.dart';
import 'package:face_recognition_with_images/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
//TODO declare variables
  late ImagePicker _imagePicker;
  String? _name;
  File? _image;

  //TODO declare detector
  late FaceDetector faceDetector;

  //TODO declare face recognizer
  late Recognizer recognizer;

  // int index = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imagePicker = ImagePicker();

    //TODO initialize face detector
    final options = FaceDetectorOptions(
      enableClassification: false,
      enableLandmarks: true,
      enableContours: false,
      enableTracking: false,
      minFaceSize: 0.1,
      performanceMode: FaceDetectorMode.accurate,
    );
    faceDetector = FaceDetector(
      options: options,
    );

    //TODO initialize face recognizer
    recognizer = Recognizer();
  }

  //TODO capture image using camera
  _imgFromCamera() async {
    // XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    // if (pickedFile != null) {
    //   setState(() {
    //     _image = File(pickedFile.path);
    //     doFaceDetection();
    //   });
    // }

    var decodedImage = await decodeImageFromList(_image!.readAsBytesSync());
    final size =
    Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());

    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);

    var painter = FacePainter(
      facesList: faces,
      imageFile: image,
    );

    painter.paint(canvas, size);
    ui.Image renderedImage = await recorder.endRecording().toImage(
      size.width.floor(),
      size.height.floor(),
    );

    var pngBytes = await renderedImage.toByteData(
      format: ui.ImageByteFormat.png,
    );

    Directory saveDir = await getApplicationDocumentsDirectory();
    File saveFile = File('${saveDir.path}/$_name');

    if (!saveFile.existsSync()) {
      saveFile.createSync(recursive: true);
    }
    saveFile.writeAsBytesSync(pngBytes!.buffer.asUint8List(), flush: true);
  }

  //TODO choose image using gallery
  _imgFromGallery() async {
    // XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    // if (pickedFile != null) {
    //   setState(() {
    //     _name = pickedFile.name;
    //     _image = File(pickedFile.path);
    //     doFaceDetection();
    //   });
    // }

    // for(int i = 1; i < 484; i++) {
    //   final byteData = await rootBundle.load('images/sources/source_$i.jpg');
    //   final file = File('${(await getTemporaryDirectory()).path}/images/sources/source_$i.jpg');
    //   await file.create(recursive: true);
    //   _image = await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    // }

    // print('===== index:: $index');

    for(int index = 1; index < 13; index++) {
      try {
        final byteData =
        await rootBundle.load('images/sources/source_$index.jpg');
        final file = File(
            '${(await getTemporaryDirectory()).path}/images/sources/source_$index.jpg');
        await file.create(recursive: true);
        await file.writeAsBytes(byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        setState(() {
          _name = 'source_$index.jpg';
          _image = file;
          doFaceDetection();
        });
      } catch (e) {
        print(e);
      }
      await Future.delayed(const Duration(seconds: 4));
      // index++;
    }

    // try {
    //   final byteData =
    //   await rootBundle.load('images/sources/source_171.jpg');
    //   final file = File(
    //       '${(await getTemporaryDirectory()).path}/images/sources/source_171.jpg');
    //   await file.create(recursive: true);
    //   await file.writeAsBytes(byteData.buffer
    //       .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    //   setState(() {
    //     _name = 'source_171.jpg';
    //     _image = file;
    //     doFaceDetection();
    //   });
    // } catch (e) {
    //   print(e);
    // }
    // await Future.delayed(const Duration(seconds: 4));
  }

  //TODO face detection code here
  List<Face> faces = [];

  doFaceDetection() async {
    //TODO remove rotation of camera images
    _image = await removeRotation(_image!);

    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);

    //TODO passing input to face detector and getting detected faces
    InputImage inputImage = InputImage.fromFile(_image!);
    faces = await faceDetector.processImage(inputImage);
    print('===== faces.length:: ${faces.length}');

    for (Face face in faces) {
      Rect faceRect = face.boundingBox;

      // num left = faceRect.left < 0 ? 0 : faceRect.left;
      // num top = faceRect.top < 0 ? 0 : faceRect.top;
      // num right =
      //     faceRect.right > image.width ? image.width - 1 : faceRect.right;
      // num bottom =
      //     faceRect.bottom > image.height ? image.height - 1 : faceRect.bottom;
      // num width = right - left;
      // num height = bottom - top;

      //TODO crop face
      // final bytes = _image!.readAsBytesSync(); //await File(cropedFace!.path).readAsBytes();
      // img.Image? faceImg = img.decodeImage(bytes!);
      // img.Image faceImg2 = img.copyCrop(
      //   faceImg!,
      //   x: left.toInt(),
      //   y: top.toInt(),
      //   width: width.toInt(),
      //   height: height.toInt(),
      // );

      // Recognition recognition = recognizer.recognize(faceImg2, faceRect);
      // showFaceRegistrationDialogue(Uint8List.fromList(img.encodeBmp(faceImg2)), recognition);
    }
    await drawRectangleAroundFaces();

    //TODO call the method to perform face recognition on detected faces
  }

  //TODO remove rotation of camera images
  removeRotation(File inputImage) async {
    final img.Image? capturedImage =
    img.decodeImage(await File(inputImage!.path).readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage!);
    return await File(_image!.path).writeAsBytes(img.encodeJpg(orientedImage));
  }

  //TODO perform Face Recognition

  //TODO Face Registration Dialogue
  TextEditingController textEditingController = TextEditingController();

  showFaceRegistrationDialogue(Uint8List cropedFace, Recognition recognition) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Face Registration", textAlign: TextAlign.center),
        alignment: Alignment.center,
        content: SizedBox(
          height: 340,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.memory(
                cropedFace,
                width: 200,
                height: 200,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Enter Name")),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    recognizer.registerFaceInDB(
                        textEditingController.text, recognition.embeddings);
                    textEditingController.text = "";
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Face Registered"),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(200, 40)),
                  child: const Text("Register"))
            ],
          ),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  //TODO draw rectangles
  var image;

  drawRectangleAroundFaces() async {
    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);
    print("${image.width}   ${image.height}");
    setState(() {
      image;
      faces;
    });

    await _imgFromCamera();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          image != null
              ?
          // Container(
          //         margin: const EdgeInsets.only(top: 100),
          //         width: screenWidth - 50,
          //         height: screenWidth - 50,
          //         child: Image.file(_image!),
          //       )
          Container(
            margin: const EdgeInsets.only(
                top: 60, left: 30, right: 30, bottom: 0),
            child: FittedBox(
              child: SizedBox(
                width: image.width.toDouble(),
                height: image.width.toDouble(),
                child: CustomPaint(
                  painter:
                  FacePainter(facesList: faces, imageFile: image),
                ),
              ),
            ),
          )
              : Container(
            margin: const EdgeInsets.only(top: 100),
            child: Image.asset(
              "images/logo.png",
              width: screenWidth - 100,
              height: screenWidth - 100,
            ),
          ),

          Container(
            height: 50,
          ),

          //TODO section which displays buttons for choosing and capturing images
          Container(
            margin: const EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(200),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      _imgFromGallery();
                    },
                    child: SizedBox(
                      width: screenWidth / 2 - 70,
                      height: screenWidth / 2 - 70,
                      child: Icon(Icons.image,
                          color: Colors.blue, size: screenWidth / 7),
                    ),
                  ),
                ),
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(200))),
                  child: InkWell(
                    onTap: () {
                      _imgFromCamera();
                    },
                    child: SizedBox(
                      width: screenWidth / 2 - 70,
                      height: screenWidth / 2 - 70,
                      child: Icon(Icons.camera,
                          color: Colors.blue, size: screenWidth / 7),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
