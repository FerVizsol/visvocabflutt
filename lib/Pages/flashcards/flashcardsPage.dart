import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:visvocabflutter/flashcard.dart';

import '../../flutter_flow/flutter_flow_theme.dart'; // Ajusta esta importación según la estructura de tu proyecto

class FlashcardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary, // Cambia el color de fondo del app bar según tu tema
        title: Text(
          'Lista de Flashcards',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Cambia el color del texto del título según tu tema
          ),
        ),
        centerTitle: true, // Centra el título en el app bar
        elevation: 0.0, // Elimina la sombra del app bar
      ),
      body: FutureBuilder<List<Flashcard>?>(
        future: HiveManager.getFlashcards(), // Usa List<Flashcard>? para que coincida con el tipo de futuro nullable
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError || snapshot.data == null) {
              return Center(child: Text('No se encontraron flashcards.'));
            } else {
              final flashcards = snapshot.data!;
              return ListView.builder(
                itemCount: flashcards.length,
                itemBuilder: (context, index) {
                  final flashcard = flashcards[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Card(
                      elevation: 2.0, // Añade elevación al card
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // Ajusta el radio de borde del card
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12.0), // Ajusta el relleno interior del ListTile
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0), // Ajusta el radio de borde de la imagen
                          child: Image.memory(
                            flashcard.image,
                            width: 70.0,
                            height: 70.0,
                            fit: BoxFit.cover, // Ajusta el modo de ajuste de la imagen
                          ),
                        ),
                        title: Text(
                          flashcard.label,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('Repetitions: ${flashcard.repetitions}'),
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
