import 'package:floor/floor.dart';

import '../../../models/article.dart';

@dao
abstract class ArticleDao {
  @Query('SELECT * FROM article')
  Future<List<ArticleModel>> getArticles();

  @insert
  Future<void> insertArticle(ArticleModel article);

  @delete
  Future<void> deleteArticle(ArticleModel article);
}
