// lib/services/news_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/article_model.dart';

class NewsService {
  static const String _apiKey = '8ebdf26a2bcf421bad909881d8efc05e';
  static const String _baseUrl = 'https://newsapi.org/v2';

  // Fetch top headlines
 Future<List<Article>> fetchTopHeadlines() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/top-headlines?country=us&apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> articlesJson = data['articles'];
      
      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  // Fetch news articles based on a search query
  Future<List<Article>> searchNews(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/everything?q=$query&apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> articlesJson = data['articles'];
      
      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search news');
    }
  }

  // Fetch news based on a specific category
  Future<List<Article>> fetchNewsByCategory(String category) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/top-headlines?category=$category&apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> articlesJson = data['articles'];
      
      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news for category: $category');
    }
  }


}
