 import 'package:flutter/material.dart';  
import 'package:provider/provider.dart';  
import '../viewmodels/news_viewmodel.dart';  
import 'article_detail_view.dart';  
import '../dbhelper/db.dart';
import '../models/article_model.dart';

class NewsListPage extends StatefulWidget {  
  @override  
  _NewsListPageState createState() => _NewsListPageState();  
}  

class _NewsListPageState extends State<NewsListPage> {  
  final TextEditingController _searchController = TextEditingController();  

  @override  
  void initState() {  
    super.initState();  
    WidgetsBinding.instance.addPostFrameCallback((_) {  
      Provider.of<NewsViewModel>(context, listen: false).fetchTopHeadlines();  
    });  
  }  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      body: CustomScrollView(  
        slivers: [  
          SliverAppBar(  
            floating: true,  
            snap: true,  
            title: Text('News Headlines', style: TextStyle(fontWeight: FontWeight.bold)),
            bottom: PreferredSize(  
              preferredSize: Size.fromHeight(70),  
              child: Padding(  
                padding: const EdgeInsets.all(8.0),  
                child: TextField(  
                  controller: _searchController,  
                  decoration: InputDecoration(  
                    hintText: 'Search news...',  
                    filled: true,  
                    fillColor: Colors.white,  
                    prefixIcon: Icon(Icons.search),  
                    suffixIcon: IconButton(  
                      icon: Icon(Icons.clear),  
                      onPressed: () {  
                        _searchController.clear();  
                        Provider.of<NewsViewModel>(context, listen: false).fetchTopHeadlines();  
                      },  
                    ),  
                    border: OutlineInputBorder(  
                      borderRadius: BorderRadius.circular(15),  
                      borderSide: BorderSide.none,  
                    ),  
                  ),  
                  onSubmitted: (value) {  
                    Provider.of<NewsViewModel>(context, listen: false).searchNews(value);  
                  },  
                ),  
              ),  
            ),  
          ),  
          Consumer<NewsViewModel>(  
            builder: (context, viewModel, child) {  
              if (viewModel.isLoading) {  
                return SliverFillRemaining(  
                  child: Center(child: CircularProgressIndicator()),  
                );  
              }  

              if (viewModel.error.isNotEmpty) {  
                return SliverFillRemaining(  
                  child: Center(child: Text('Error: ${viewModel.error}')),  
                );  
              }  

              return SliverList(  
                delegate: SliverChildBuilderDelegate(  
                  (context, index) {  
                    final article = viewModel.articles[index];  
                    final isSaved = viewModel.savedArticles.contains(article);

                    return Padding(  
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),  
                      child: Container(  
                        decoration: BoxDecoration(  
                          color: Colors.white,  
                          borderRadius: BorderRadius.circular(15),  
                          boxShadow: [  
                            BoxShadow(  
                              color: Colors.black12,  
                              blurRadius: 10,  
                              offset: Offset(0, 4),  
                            ),  
                          ],  
                        ),  
                        child: ListTile(  
                          contentPadding: EdgeInsets.all(10),  
                          title: Text(  
                            article.title,  
                            maxLines: 2,  
                            overflow: TextOverflow.ellipsis,  
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),  
                          ),  
                          subtitle: Text(  
                            article.description ?? '',  
                            maxLines: 2,  
                            overflow: TextOverflow.ellipsis,  
                          ),  
                          leading: article.urlToImage.isNotEmpty  
                              ? ClipRRect(  
                                  borderRadius: BorderRadius.circular(10),  
                                  child: Image.network(  
                                    article.urlToImage,  
                                    width: 100,  
                                    height: 100,  
                                    fit: BoxFit.cover,  
                                  ),  
                                )  
                              : null,  
                          trailing: IconButton(
                            icon: Icon(
                              isSaved ? Icons.bookmark : Icons.bookmark_border,
                              color: isSaved ? Colors.blue : null,
                            ),
                            onPressed: () async{
                              if (isSaved) {
                                 //await DBHelper.instance.deleteArticle(article.id.toString());
                                viewModel.unsaveArticle(article);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Article removed from saved'))
                                );
                              } else {
                                int id = await DBHelper.instance.insertArticles({
                                          "title": article.title,
                                          "description": article.description,
                                          "url": article.url,
                                          "content": article.content,
                                          "author": article.author,
                                          "publishedAt":article.publishedAt,
                                          "urlToImage": article.urlToImage,
                                        });
                                        print(id);
                                viewModel.saveArticle(article);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Article saved'))
                                );
                              }
                            },
                          ),
                          onTap: () {  
                            Navigator.push(  
                              context,  
                              MaterialPageRoute(  
                                builder: (context) => ArticleDetailView(article: article),  
                              ),  
                            );  
                          },  
                        ),  
                      ),  
                    );  
                  },  
                  childCount: viewModel.articles.length,  
                ),  
              );  
            },  
          ),  
        ],  
      ),  
    );  
  }
}