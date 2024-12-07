import 'package:flutter/material.dart';
import '../services/news_service.dart';
import '../models/article_model.dart';

class NewsDetailPage extends StatefulWidget {
  final String category;

  NewsDetailPage({required this.category});

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  List<Article> newsArticles = [];
  bool isLoading = true;
  final NewsService newsService = NewsService();

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      final fetchedNews = await newsService.fetchNewsByCategory(widget.category.toLowerCase());
      setState(() {
        isLoading = false;
        newsArticles = fetchedNews;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        newsArticles = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} News', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: newsArticles.length,
              itemBuilder: (context, index) {
                final article = newsArticles[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: Column(
                      children: [
                        // Display image
                        article.urlToImage.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: Image.network(
                                  article.urlToImage,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                height: 200,
                                color: Colors.grey[200],
                                child: Center(child: Text("No Image Available")),
                              ),
                        // Title and description
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                article.description ?? 'No description available',
                                style: TextStyle(fontSize: 14, color: Colors.black54),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    article.publishedAt ?? 'Unknown date',
                                    style: TextStyle(fontSize: 12, color: Colors.black45),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
