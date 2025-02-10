import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/article.dart';
import '../../bloc/article/remote/remote_articles_bloc.dart';
import '../../widgets/article_tile.dart';
import '../article_detail/article_detail.dart';
import '../saved_article/saved_article.dart';

class DailyNewsScreen extends StatelessWidget {
  const DailyNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppbar(context), body: _buildBody());
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
      title: const Text('Daily News', style: TextStyle(color: Colors.black)),
      actions: [
        GestureDetector(
          onTap: () => _onShowSavedArticlesViewTapped(context),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Icon(Icons.bookmark, color: Colors.black),
          ),
        ),
      ],
    );
  }

  _buildBody() {
    return BlocBuilder<RemoteArticlesBloc, RemoteArticlesState>(
      builder: (_, state) {
        if (state is RemoteArticlesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is RemoteArticlesError) {
          debugPrint(state.error!.message);
          return const Center(child: Icon(Icons.refresh));
        }
        if (state is RemoteArticlesDone) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return ArticleTile(
                article: state.articles![index],
                onArticlePressed: (article) => _onArticlePressed(context, article),
              );
            },
            itemCount: state.articles!.length,
          );
        }
        return const SizedBox();
      },
    );
  }

  void _onArticlePressed(BuildContext context, ArticleEntity article) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ArticleDetailScreen(article: article)),
    );
  }

  void _onShowSavedArticlesViewTapped(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SavedArticlesScreen()));
  }
}
