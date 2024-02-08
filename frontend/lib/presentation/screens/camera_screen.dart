import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/preview_page.dart';
import 'package:frontend/services/document_service.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  CameraScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  bool isCameraReady = false;
  final DocumentService documentService = DocumentService();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: isCameraReady == true &&
                _cameraController.value.isInitialized == true
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    SizedBox(
                        width: size.width,
                        height: size.height * 0.86,
                        child: FittedBox(
                            fit: BoxFit.cover,
                            child: Container(
                                width: 100,
                                child: CameraPreview(_cameraController)))),
                    Container(
                        color: Colors.black,
                        width: size.width,
                        height: size.height * 0.14,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.flash_off)),
                            GestureDetector(
                                onTap: () {
                                  _takePicture();
                                },
                                child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white))),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.flip_camera_ios))
                          ],
                        ))
                  ])
            : const Center(child: CircularProgressIndicator()));
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final rearCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);

    _cameraController = CameraController(rearCamera, ResolutionPreset.max);
    try {
      _cameraController.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          isCameraReady = true;
        });
      });
    } on CameraException catch (e) {
      debugPrint("Camera Error: $e");
    }
  }

  Future _takePicture() async {
    if (_cameraController.value.isInitialized == false ||
        _cameraController.value.isTakingPicture) {
      return;
    }

    XFile picture = await _cameraController.takePicture();

    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PreviewPage(
            picture: picture,
            onClose: () {
              Navigator.pop(context);
              _cameraController.resumePreview();
            },
            onSend: () {
              Navigator.pop(context);
              Navigator.pop(context, picture);
            })));
  }
}
