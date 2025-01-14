import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:face_recognition_with_images/ml/recognition.dart';
import 'package:face_recognition_with_images/ml/recognizer.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui show Codec, FrameInfo, Image, ImmutableBuffer;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _HomePageState();
}

class _HomePageState extends State<RegistrationScreen> {
  //TODO declare variables
  late ImagePicker imagePicker;
  File? _image;

  //TODO declare detector
  late FaceDetector faceDetector;

  //TODO declare face recognizer
  late Recognizer recognizer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();

    //TODO initialize face detector
    // FaceDetectorOptions({
    //   this.enableClassification = false,
    //   enableClassification
    //   그 사람의 얼굴이 눈을 뜨고 있는지 감고 있는지를 감지하는 것입니다.
    //   마찬가지로, 얼굴이 진지하거나 웃고 있는지도 감지할 수 있습니다.

    //   this.enableLandmarks = false,
    //   enableLandmarks
    //   코, 눈, 뺨, 입 등 다양한 얼굴 랜드마크의 위치도 알아야 합니까?

    //   this.enableContours = false,
    //   enableContours
    //   그런 다음 랜드마크와 유사한 윤곽선 감지를 얻었습니다.
    //   그러나 랜드마크를 사용하면 정확한 위치나 다른 랜드마크를 나타내는 지점을 얻을 수 있습니다.

    //   this.enableTracking = false,
    //   enableTracking
    //   그런 다음 얼굴 추적을 활성화하거나 비활성화할 수도 있습니다.
    //   따라서 이 기능을 활성화하면 얼굴 감지 모델은 각 얼굴에 고유한 ID를 할당하려고 시도합니다.

    //   this.minFaceSize = 0.1,
    //   minFaceSize
    //   그런 다음 감지해야 하는 최소 얼굴 크기를 지정할 수 있습니다.

    //   this.performanceMode = FaceDetectorMode.fast,

    // })
    final options = FaceDetectorOptions(
      enableClassification: false,
      enableLandmarks: true,
      enableContours: false,
      enableTracking: false,
      minFaceSize: 0.1,
      // enableTracking: true,
      performanceMode: FaceDetectorMode.accurate,
    );
    faceDetector = FaceDetector(options: options);

    //TODO initialize face recognizer
    recognizer = Recognizer();
  }

  //TODO capture image using camera
  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doFaceDetection();
      });
    }
  }

  //TODO choose image using gallery
  _imgFromGallery() async {
    faces.clear();
    largeFaces.clear();
    // maxArea = 0;
    // largestFace = null;
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doFaceDetection();
      });
    }
  }

  //TODO face detection code here
  List<Face> faces = [];
  List<Face> largeFaces = [];
  double ratio = 0;

  doFaceDetection() async {
    //TODO remove rotation of camera images

    // get width, height
    // Uint8List? readAsBytesImage = await _image?.readAsBytes();
    // ui.Image decodeImage = await decodeImageFromList(readAsBytesImage!);

    ui.Image decodeImage = await decodeImageFromList(_image!.readAsBytesSync());

    //TODO passing input to face detector and getting detected faces
    InputImage inputImage = InputImage.fromFile(_image!);
    faces = await faceDetector.processImage(inputImage);

    // 내림차순 정렬
    // faces.sort((a, b) {
    //   final double areaA = a.boundingBox.width * a.boundingBox.height;
    //   final double areaB = b.boundingBox.width * b.boundingBox.height;
    //   return areaB.compareTo(areaA);
    // });

    // ratio = ((faces[1].boundingBox.width * faces[1].boundingBox.height) /
    //         (faces[0].boundingBox.width * faces[0].boundingBox.height)) *
    //     100;
    // print('face ratio :: $ratio');

    // // rect1의 왼쪽 경계
    // final x1 = faces[0].boundingBox.left;
    // // rect1의 위쪽 경계
    // final y1 = faces[0].boundingBox.top;
    // // rect1의 오른쪽 경계
    // final x2 = faces[0].boundingBox.right;
    // // rect1의 아래쪽 경계
    // final y2 = faces[0].boundingBox.bottom;
    //
    // // rect2의 왼쪽 경계
    // final x3 = faces[1].boundingBox.left;
    // // rect2의 위쪽 경계
    // final y3 = faces[1].boundingBox.top;
    // // rect2의 오른쪽 경계
    // final x4 = faces[1].boundingBox.right;
    // // rect2의 아래쪽 경계
    // final y4 = faces[1].boundingBox.bottom;
    //
    // // 교차 영역의 좌표 계산
    // // 교차 영역의 왼쪽 경계
    // final interLeft = x1 > x3 ? x1 : x3;
    // // 교차 영역의 위쪽 경계
    // final interTop = y1 > y3 ? y1 : y3;
    // // 교차 영역의 오른쪽 경계
    // final interRight = x2 < x4 ? x2 : x4;
    // // 교차 영역의 아래쪽 경계
    // final interBottom = y2 < y4 ? y2 : y4;
    //
    // // 교차 영역의 너비와 높이 계산
    // final interWidth = (interRight - interLeft).clamp(0, double.infinity);
    // final interHeight = (interBottom - interTop).clamp(0, double.infinity);
    //
    // // 교차 영역의 면적 계산
    // final intersection = interWidth * interHeight;
    //
    // // 각 사각형의 면적 계산
    // final area1 = faces[0].boundingBox.width * faces[0].boundingBox.height;
    // final area2 = faces[1].boundingBox.width * faces[1].boundingBox.height;
    //
    // // 합집합 면적 계산
    // final union = area1 + area2 - intersection;
    //
    // // IoU
    // print('===== intersection / union :: ${intersection / union}');

    for (Face face in faces) {
      Rect faceRect = face.boundingBox;
      print('Rect = ' + faceRect.toString());

      num left = faceRect.left < 0 ? 0 : faceRect.left;
      num top = faceRect.top < 0 ? 0 : faceRect.top;
      num right = faceRect.right > decodeImage.width
          ? decodeImage.width - 1
          : faceRect.right;
      num bottom = faceRect.bottom > decodeImage.height
          ? decodeImage.height - 1
          : faceRect.bottom;
      num width = right - left;
      num height = bottom - top;

      //TODO crop face
      final bytes = _image!
          .readAsBytesSync(); //await File(cropedFace!.path).readAsBytes();
      img.Image? faceImg = img.decodeImage(bytes!);
      // crop image
      img.Image faceImg2 = img.copyCrop(
        faceImg!,
        x: left.toInt(),
        y: top.toInt(),
        width: width.toInt(),
        height: height.toInt(),
      );

      // 두 번째로 얼굴의 위치를 지정해야 합니다.
      // 따라서 얼굴의 위치는 이 경계 상자 또는 직사각형 개체 내부에 저장됩니다.
      Recognition recognition = recognizer.recognize(faceImg2, faceRect);
      showFaceRegistrationDialogue(
        Uint8List.fromList(
          img.encodeBmp(faceImg2),
        ),
        recognition,
      );
    }

    // largeFaces.add(largestFace!);
    // print('largeFaces length :: ${largeFaces.length}');

    drawRectangleAroundFaces();
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
                    hintText: "Enter Name",
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  recognizer.registerFaceInDB(
                    textEditingController.text,
                    recognition.embeddings,
                  );
                  textEditingController.text = "";
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Face Registered"),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  // primary: Colors.blue,
                  foregroundColor: Colors.blue,
                  minimumSize: const Size(200, 40),
                ),
                child: const Text("Register"),
              )
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
      // largeFaces;
    });
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
                        painter: FacePainter(
                          facesList: faces,
                          // facesList: largeFaces,
                          imageFile: image,
                        ),
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
                      borderRadius: BorderRadius.all(Radius.circular(200))),
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
                      child: Icon(
                        Icons.camera,
                        color: Colors.blue,
                        size: screenWidth / 7,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  List<Face> facesList;
  dynamic imageFile;

  FacePainter({
    required this.facesList,
    @required this.imageFile,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(
        imageFile,
        // 0, 0 또는 캔버스의 왼쪽 상단 지점
        Offset.zero,
        Paint(),
      );
    }

    Paint p = Paint();
    p.color = Colors.red;
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 3;

    for (Face face in facesList) {
      canvas.drawRect(
        face.boundingBox,
        p,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
