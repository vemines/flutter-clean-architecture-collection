import '../../../../core/usecase/usecase.dart';
import '../entities/article.dart';
import '../repositories/article_repository.dart';

class RemoveArticleUseCase implements UseCase<void, ArticleEntity> {
  final ArticleRepository _articleRepository;

  RemoveArticleUseCase(this._articleRepository);
  @override
  Future<void> call({ArticleEntity? article}) {
    return _articleRepository.removeArticle(article!);
  }
}
