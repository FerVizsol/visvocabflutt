import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:visvocabflutter/flashcard.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/internationalization.dart';

class FlashcardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        title: Text(
          FFLocalizations.of(context).getText('flash2'),
          style: FlutterFlowTheme.of(context).headlineMedium.override(
            fontFamily: 'Lexend',
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: FutureBuilder<List<Flashcard>?>(
        future: HiveManager.getFlashcards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError || snapshot.data == null) {
              return Center(child: Text(FFLocalizations.of(context).getText('flash1')));//No se encontraron flashcards
            } else {
              final flashcards = snapshot.data!;
              return ListView.builder(
                itemCount: flashcards.length,
                itemBuilder: (context, index) {
                  final flashcard = flashcards[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12.0),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.memory(
                            flashcard.image,
                            width: 70.0,
                            height: 70.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          flashcard.label,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text( '${FFLocalizations.of(context).getText('flash3')}${flashcard.easeFactor}'),
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
