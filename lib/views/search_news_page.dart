import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class SearchNewsPage extends StatefulWidget {
  const SearchNewsPage({Key? key}) : super(key: key);

  @override
  _SearchNewsPageState createState() => _SearchNewsPageState();
}

class _SearchNewsPageState extends State<SearchNewsPage> {
  final TextEditingController _searchController = TextEditingController();
  final String _apiKey = '8ebdf26a2bcf421bad909881d8efc05e'; // API key
  final Dio _dio = Dio();

  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Add a listener to handle real-time searching
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (_searchController.text.isNotEmpty) {
        _searchNews(_searchController.text);
      } else {
        setState(() {
          _searchResults = [];
        });
      }
    });
  }

  Future<void> _searchNews(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch articles from the API
      final response = await _dio.get(
        'https://newsapi.org/v2/everything',
        queryParameters: {
          'q': query,
          'apiKey': _apiKey,
          'language': 'en',
          'sortBy': 'relevancy',
        },
      );

      List<dynamic> articles = response.data['articles'] ?? [];

      // Filter articles to include only those with matching titles
      articles = articles.where((article) {
        final title = article['title']?.toString().toLowerCase() ?? '';
        return title.contains(query.toLowerCase());
      }).toList();

      setState(() {
        _searchResults = articles;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching news: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search news...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? const Center(child: Text('No results found. Start searching!'))
              : ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final article = _searchResults[index];
                    return ListTile(
                      leading: article['urlToImage'] != null
                          ? Image.network(
                              article['urlToImage'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image_not_supported, size: 50),
                      title: Text(article['title'] ?? 'No Title'),
                      subtitle: Text(article['description'] ?? 'No Description'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleDetailView(
                              title: article['title'] ?? 'No Title',
                              url: article['url'] ?? '',
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

class ArticleDetailView extends StatelessWidget {
  final String title;
  final String url;

  const ArticleDetailView({Key? key, required this.title, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Detailed view of the article is under construction.'),
            ElevatedButton(
              onPressed: () {
                // Add your logic for opening the article in a web view
              },
              child: const Text('Open Article'),
            ),
          ],
        ),
      ),
    );
  }
}
