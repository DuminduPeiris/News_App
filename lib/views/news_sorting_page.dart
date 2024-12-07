import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/news_viewmodel.dart';

class NewsSortingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newsViewModel = context.watch<NewsViewModel>();

    return ListView.builder(
      itemCount: newsViewModel.articles.length,
      itemBuilder: (context, index) {
        final article = newsViewModel.articles[index];
        return ListTile(
          title: Text(article.title),
         // subtitle: Text(article.publishedAt.toLocal().toString()),
        );
      },
    );
  }
}