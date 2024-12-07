// import 'package:flutter/foundation.dart';
// import '../models/article_model.dart';
// import '../services/news_service.dart';

// class NewsViewModel extends ChangeNotifier {
//   final NewsService _newsService = NewsService();

//   List<Article> _articles = [];
//   List<Article> _savedArticles = []; // New list for saved articles

//   List<Article> get articles => _articles;
//   List<Article> get savedArticles => _savedArticles; // Getter for saved articles

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   String _error = '';
//   String get error => _error;

//   Future<void> fetchTopHeadlines() async {
//     _isLoading = true;
//     _error = '';
//     notifyListeners();

//     try {
//       _articles = await _newsService.fetchTopHeadlines();
//     } catch (e) {
//       _error = e.toString();
//     }

//     _isLoading = false;
//     notifyListeners();
//   }

//   Future<void> searchNews(String query) async {
//     _isLoading = true;
//     _error = '';
//     notifyListeners();

//     try {
//       _articles = await _newsService.searchNews(query);
//     } catch (e) {
//       _error = e.toString();
//     }

//     _isLoading = false;
//     notifyListeners();
//   }

//   // New method to save an article
//   void saveArticle(Article article) {
//     // Check if the article is not already saved
//     if (!_savedArticles.contains(article)) {
//       _savedArticles.add(article);
//       notifyListeners();
//     }
//   }

//   // New method to unsave/remove an article
//   void unsaveArticle(Article article) {
//     _savedArticles.remove(article);
//     notifyListeners();
//   }

// }

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';
import '../services/news_service.dart';

class NewsViewModel extends ChangeNotifier {
  final NewsService _newsService = NewsService();

  List<Article> _articles = [];
  List<Article> _savedArticles = []; // List for saved articles

  List<Article> get articles => _articles;
  List<Article> get savedArticles => _savedArticles; // Getter for saved articles

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = '';
  String get error => _error;

  // Fetch top headlines
  Future<void> fetchTopHeadlines() async {
    _setLoadingState(true);
    _clearErrorState();

    try {
      _articles = await _newsService.fetchTopHeadlines();
    } catch (e) {
      _setErrorState(e.toString());
    }

    _setLoadingState(false);
  }

  // Search news based on the query
  Future<void> searchNews(String query) async {
    _setLoadingState(true);
    _clearErrorState();

    try {
      _articles = await _newsService.searchNews(query);
    } catch (e) {
      _setErrorState(e.toString());
    }

    _setLoadingState(false);
  }

  // Save an article
  void saveArticle(Article article) {
    if (!_savedArticles.contains(article)) {
      _savedArticles.add(article);
      notifyListeners();
    }
  }

  // Unsave/remove an article
  void unsaveArticle(Article article) {
    _savedArticles.remove(article);
    notifyListeners();
  }

  // Filter articles by date range
  Future<void> filterArticlesByDateRange(DateTime startDate, DateTime endDate) async {
    _setLoadingState(true);
    _clearErrorState();

    try {
      // Format dates to the required format (YYYY-MM-DD)
      final String formattedStartDate = startDate.toIso8601String().substring(0, 10);
      final String formattedEndDate = endDate.toIso8601String().substring(0, 10);

      // Construct the NewsAPI URL
      final String apiKey = '8ebdf26a2bcf421bad909881d8efc05e';
      final String url =
          "https://newsapi.org/v2/everything?q=*&from=$formattedStartDate&to=$formattedEndDate&apiKey=$apiKey";

      // Perform the API request
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'ok' && jsonResponse['articles'] != null) {
          // Convert articles into a list
          final List<dynamic> articles = jsonResponse['articles'];
          _articles = articles.map((e) => Article.fromMap(e)).toList();

          if (_articles.isEmpty) {
            _setErrorState("No articles found within the selected date range.");
          } else {
            _clearErrorState();
          }
        } else {
          _setErrorState("Failed to retrieve articles. Error: ${jsonResponse['message'] ?? 'Unknown error'}");
        }
      } else {
        _setErrorState("HTTP Error: ${response.statusCode}. Failed to fetch articles.");
      }
    } catch (e) {
      _setErrorState("Failed to filter articles by date range. Error: $e");
      debugPrint("Error in filterArticlesByDateRange: $e");
    }

    _setLoadingState(false);
  }

  // Helper function to update loading state
  void _setLoadingState(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Helper function to clear error state
  void _clearErrorState() {
    _error = '';
  }

  // Helper function to set error state
  void _setErrorState(String message) {
    _error = message;
    notifyListeners();
  }
}