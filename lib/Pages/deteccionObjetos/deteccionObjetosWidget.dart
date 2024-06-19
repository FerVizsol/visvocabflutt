import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:typed_data';
import 'deteccionObjetosModel.dart';
export 'deteccionObjetosModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:visvocabflutter/flashcard.dart';

class DeteccionObjetosWidget extends StatefulWidget {
  const DeteccionObjetosWidget({super.key});
  @override
  State<DeteccionObjetosWidget> createState() => _DeteccionObjetosWidgetState();
}

class _DeteccionObjetosWidgetState extends State<DeteccionObjetosWidget> {
  late DeteccionObjetosModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  static const platform = MethodChannel('com.example.visualvocab/detect');

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DeteccionObjetosModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _showPreviewDialog(Uint8List imageBytes, String label) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // No se puede cerrar tocando fuera del diálogo
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Guardado'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.memory(imageBytes),
                SizedBox(height: 20),
                Text('Etiqueta: $label'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () {
                _saveFlashcard(imageBytes, label);
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveFlashcard(Uint8List imageBytes, String label) async {
    final flashcardBox = Hive.box<Flashcard>('flashcards');
    final newFlashcard = Flashcard(imageBytes, label);
    flashcardBox.add(newFlashcard);
    Fluttertoast.showToast(
        msg: "Flashcard guardada",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  Future<void> _detectObject(Uint8List imageBytes) async {
    try {
      final result = await platform.invokeMethod('detectObject', imageBytes);
      await _showPreviewDialog(imageBytes, result);
    } on PlatformException catch (e) {
      Fluttertoast.showToast(
          msg: "Detección Fallida: ${e.message}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        title: Align(
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Text(
            'Detectar Objetos',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'Lexend',
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: false,
        elevation: 2.0,
      ),
      body: SafeArea(
        child: Align(
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: InkWell(
                  onTap: () async {
                    final selectedMedia = await selectMedia(multiImage: false);
                    if (selectedMedia != null && selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
                      setState(() => _model.isDataUploading1 = true);
                      var selectedUploadedFiles = <FFUploadedFile>[];

                      try {
                        selectedUploadedFiles = selectedMedia.map((m) => FFUploadedFile(
                          name: m.storagePath.split('/').last,
                          bytes: m.bytes,
                          height: m.dimensions?.height,
                          width: m.dimensions?.width,
                          blurHash: m.blurHash,
                        )).toList();
                      } finally {
                        _model.isDataUploading1 = false;
                      }
                      if (selectedUploadedFiles.length == selectedMedia.length) {
                        setState(() {
                          _model.uploadedLocalFile1 = selectedUploadedFiles.first;
                        });
                        await _detectObject(selectedUploadedFiles.first.bytes!);
                      } else {
                        setState(() {});
                        return;
                      }
                    }
                  },
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Color(0x3F14181B),
                          offset: Offset(0.0, 3.0),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Agregar nuevos objetos a través de la cámara',
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Lexend',
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 12.0),
                            child: Text(
                              'TOMAR FOTO DE OBJETO',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context).displaySmall.override(
                                fontFamily: 'Lexend',
                                color: FlutterFlowTheme.of(context).tertiary,
                                fontSize: 30.0,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.camera_alt,
                            color: FlutterFlowTheme.of(context).tertiary,
                            size: 50.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: InkWell(
                  onTap: () async {
                    final selectedMedia = await selectMedia(mediaSource: MediaSource.photoGallery, multiImage: false);
                    if (selectedMedia != null && selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
                      setState(() => _model.isDataUploading2 = true);
                      var selectedUploadedFiles = <FFUploadedFile>[];

                      try {
                        selectedUploadedFiles = selectedMedia.map((m) => FFUploadedFile(
                          name: m.storagePath.split('/').last,
                          bytes: m.bytes,
                          height: m.dimensions?.height,
                          width: m.dimensions?.width,
                          blurHash: m.blurHash,
                        )).toList();
                      } finally {
                        _model.isDataUploading2 = false;
                      }
                      if (selectedUploadedFiles.length == selectedMedia.length) {
                        setState(() {
                          _model.uploadedLocalFile2 = selectedUploadedFiles.first;
                        });
                        await _detectObject(selectedUploadedFiles.first.bytes!);
                      } else {
                        setState(() {});
                        return;
                      }
                    }
                  },
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Color(0x3F14181B),
                          offset: Offset(0.0, 3.0),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Subir una imagen del objeto a través de la galería',
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Lexend',
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 12.0),
                            child: Text(
                              'SUBIR DESDE GALERÍA',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context).displaySmall.override(
                                fontFamily: 'Lexend',
                                color: FlutterFlowTheme.of(context).tertiary,
                                fontSize: 30.0,
                              ),
                            ),
                          ),
                          FaIcon(
                            FontAwesomeIcons.photoVideo,
                            color: FlutterFlowTheme.of(context).tertiary,
                            size: 50.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
