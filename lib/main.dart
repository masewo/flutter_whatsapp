import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/src/app.dart';

import 'package:camera/camera.dart';
import 'package:flutter_whatsapp/src/helpers/logger.dart';
import 'package:flutter_whatsapp/src/screens/camera_screen.dart';
// import 'package:fast_qr_reader_view/fast_qr_reader_view.dart' as qr;

//void main() {
//  runApp(FlutteredApp());
//}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  
  // Fetch the available cameras before initializing the app.
  try {
    cameras = await availableCameras();
    // qrCameras = await qr.availableCameras();
  } on CameraException catch (e) {
    logger.d('CameraException:\n${e.code}\n${e.description}');
  } 
  // on qr.QRReaderException catch(e) {
  //   logger.d(e.code+'\n'+ e.description);
  // }
  runApp(const FlutteredApp());
}