import 'package:flutter/material.dart';

import 'package:speaking_sign/config/constants/constants.dart';
import 'package:speaking_sign/presentation/screens/word_detaile/word_detaile_view.dart';
import 'package:speaking_sign/routes/app_routes.dart';

/// Controller for DictionaryGridView
/// Handles word list data and navigation logic
class DictionaryGridController extends ChangeNotifier {
  /// Get all words from animations dictionary
  /// This ensures data consistency between itemCount and actual displayed items
  List<String> get words => animations.keys.toList();

  /// Get word count
  int get wordCount => words.length;

  /// Handle word tap navigation
  /// Navigates to WordDetailView with the selected word
  void onWordTapped(BuildContext context, String word) {
    Navigator.pushNamed(context, AppRoutes.WordDetaileView, arguments: word);
  }

  /// Get word by index (for safe access)
  String getWordAt(int index) {
    if (index >= 0 && index < words.length) {
      return words[index];
    }
    return '';
  }
}
