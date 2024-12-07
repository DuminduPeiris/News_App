import 'package:flutter/material.dart';
import '../dbhelper/db.dart';
import '../models/article_model.dart';
import '../viewmodels/news_viewmodel.dart';
import '../models/article_model.dart';
import 'article_detail_view.dart';


class SavedArticlesPage extends StatefulWidget {
  @override
  _SavedArticlesPageState createState() => _SavedArticlesPageState();
}

class _SavedArticlesPageState extends State<SavedArticlesPage> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
  backgroundColor: Colors.white,
  appBar: AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    title: Text(
      'Saved Articles',
      style: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    ),
    centerTitle: true,
  ),
  body: FutureBuilder(
    
    future: DBHelper.instance.getArticles(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
            ),
          ),
        );
      } else if (snapshot.hasError) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 80,
              ),
              SizedBox(height: 20),
              Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                'Error: ${snapshot.error}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        );
      } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
        final articles = snapshot.data!;
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return Container(
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Dismissible(
                key: Key(article.url),
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  print("delete saved article " +article.id.toString());
                  await DBHelper.instance.deleteArticle(article.id);
                   
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Article removed'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                 
                },
                child: ListTile(
                  contentPadding: EdgeInsets.all(12),
                  title: Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple[800],
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      article.description ?? 'No description available',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Colors.deepPurple[300],
                    size: 30,
                  ),
                  onTap: () {
                    print("Sample article"+ article.id.toString());

                    // Uncomment when ready to implement article detail view
                    //  Navigator.push(  
                    //           context,  
                    //           MaterialPageRoute(  
                    //             builder: (context) => ArticleDetailView(article: article),  
                    //           ),  
                    //         );  
                  },
                ),
              ),
            );
          },
        );
      } else {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bookmark_border,
                size: 100,
                color: Colors.grey[300],
              ),
              SizedBox(height: 20),
              Text(
                'No Saved Articles',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Save articles to read them later',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        );
      }
    },
  ),
);
  }
}
