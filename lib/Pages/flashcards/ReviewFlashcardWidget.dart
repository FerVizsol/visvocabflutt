import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visvocabflutter/flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import 'ReviewFlashcardModel.dart';
import 'reviewpage.dart';

class ReviewFlashcardWidget extends StatefulWidget {
  const ReviewFlashcardWidget({Key? key}) : super(key: key);

  @override
  State<ReviewFlashcardWidget> createState() => _ReviewFlashcardWidgetState();
}

class _ReviewFlashcardWidgetState extends State<ReviewFlashcardWidget> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReviewFlashcardModel(),
      child: Consumer<ReviewFlashcardModel>(
        builder: (context, model, _) => Scaffold(
          key: GlobalKey<ScaffoldState>(),
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            title: Text(FFLocalizations.of(context).getText('revflash1')),//review flashcards
            titleTextStyle: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'Lexend',
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
            ),
            backgroundColor: FlutterFlowTheme.of(context).primary,
          ),
          body: model.flashcardsToReview.isEmpty
              ? Center(
            child: Text(FFLocalizations.of(context).getText('revflash2')),
          )
              : ListView.builder(
            itemCount: model.flashcardsToReview.length,
            itemBuilder: (context, index) {
              final flashcard = model.flashcardsToReview[index];
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
                        fit: BoxFit.cover, // Adjusts the image fit mode
                      ),
                    ),
                    title: Text(
                      flashcard.label,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('${FFLocalizations.of(context).getText('revflash3')}${flashcard.nextReviewDate}'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ReviewPage(flashcard: flashcard),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          )
        ),
      ),
    );
  }
}
