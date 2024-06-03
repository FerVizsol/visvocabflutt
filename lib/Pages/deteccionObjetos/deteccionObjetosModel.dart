import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../flutter_flow/flutter_flow_model.dart';
import '../../flutter_flow/uploaded_file.dart';
import '/flutter_flow/upload_data.dart';
import 'deteccionObjetosWidget.dart' show DeteccionObjetosWidget;

class DeteccionObjetosModel extends FlutterFlowModel<DeteccionObjetosWidget> {
  final unfocusNode = FocusNode();
  bool isDataUploading1 = false;
  FFUploadedFile uploadedLocalFile1 = FFUploadedFile(bytes: Uint8List.fromList([]));

  bool isDataUploading2 = false;
  FFUploadedFile uploadedLocalFile2 = FFUploadedFile(bytes: Uint8List.fromList([]));
  @override
  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
  }
}
