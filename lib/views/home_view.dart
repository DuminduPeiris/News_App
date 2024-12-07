import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'search_news_page.dart';
import 'news_list_page.dart';
import 'category_page.dart';
import 'saved_articles_page.dart';
import '../dbhelper/db.dart';
import '../viewmodels/news_viewmodel.dart';

// Add the SavedArticlesProvider class
class SavedArticlesProvider extends ChangeNotifier {
  final Set<Article> _savedArticles = {};

  Set<Article> get savedArticles => _savedArticles;

  bool isArticleSaved(Article article) {
    return _savedArticles.contains(article);
  }

}


// Method to show date range picker
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? selectedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(Duration(days: 30)),
        end: DateTime.now(),
      ),
    );

    if (selectedRange != null) {
      // Call the method to filter articles by the selected date range
      context.read<NewsViewModel>().filterArticlesByDateRange(
        selectedRange.start,
        selectedRange.end,
      );
    }
  }

// Example Article class
class Article {
  final int id;
  final String title;
  final String url;
  final String description;
  final String content;
  final String author;
  final String publishedAt;
  final String?  urlToImage;

  const Article({
    this.id = 0,
    required this.title,
    required this.url,
    required this.description,
    required this.content,
    required this.author,
    required this.publishedAt,
     this.urlToImage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Article && runtimeType == other.runtimeType && title == other.title && url == other.url;

  @override
  int get hashCode => title.hashCode ^ url.hashCode;
}

// HomeView - Main Screen
class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      NewsListPage(),
      CategoryPage(),
      SavedArticlesPage(), // This will show saved articles
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewsViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('News App'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SearchNewsPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.filter_alt),
              onPressed: ()  => _selectDateRange(context),
            ),
          ],
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Headlines',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Saved Articles',
            ),
          ],
        ),
      ),
    );
  }
  
}
