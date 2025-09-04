import 'dart:typed_data';

import 'package:ai_training/app_constants/app_constants.dart';
import 'package:firebase_ai/firebase_ai.dart';

class AiTranslatorService {
  final GenerativeModel _model;

  AiTranslatorService()
      : _model = FirebaseAI.googleAI().generativeModel(
          model: 'gemini-2.0-flash',
        );

  Future<String?> recognizeAndTranslate(String item, Uint8List image) async {
    final response = await _model.generateContent([
      Content.multi([
        TextPart(AppConstants.translatorPrompt),
        InlineDataPart('image/jpeg', image)
      ]),
    ]);

    if (response.text?.contains('No English text was found') ?? false) {
      throw Exception(
          response.text?.replaceAll('No English text was found.', ''));
    }

    return response.text;
  }
}
