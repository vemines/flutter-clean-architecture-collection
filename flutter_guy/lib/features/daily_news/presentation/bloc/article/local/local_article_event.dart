import '../../../../domain/entities/article.dart';

abstract class LocalArticlesEvent {
  final ArticleEntity? article;
  const LocalArticlesEvent({this.article});
}

class GetSavedArticles extends LocalArticlesEvent {
  const GetSavedArticles();
}

class RemoveArticle extends LocalArticlesEvent {
  const RemoveArticle(ArticleEntity article) : super(article: article);
}

class SaveArticle extends LocalArticlesEvent {
  const SaveArticle(ArticleEntity article) : super(article: article);
}
