import 'package:floor/floor.dart';

import '../../domain/entities/article.dart';

class ArticleResponseModel {
  final List<ArticleModel> articles;

  ArticleResponseModel({required this.articles});

  factory ArticleResponseModel.fromJson(Map<String, dynamic> articleResponseData) {
    return ArticleResponseModel(
      articles:
          ((articleResponseData['articles'] ?? []) as List<dynamic>)
              .map((dynamic article) => ArticleModel.fromJson(article))
              .toList(),
    );
  }
}

@Entity(tableName: 'article', primaryKeys: ['id'])
class ArticleModel extends ArticleEntity {
  const ArticleModel({
    super.id,
    super.author,
    super.title,
    super.description,
    super.url,
    super.urlToImage,
    super.publishedAt,
    super.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> map) => ArticleModel(
    author: map['author'] ?? '',
    title: map['title'] ?? '',
    description: map['description'] ?? '',
    url: map['url'] ?? '',
    urlToImage: map['urlToImage'] ?? '',
    publishedAt: map['publishedAt'] ?? '',
    content: map['content'] ?? '',
  );

  factory ArticleModel.fromEntity(ArticleEntity entity) => ArticleModel(
    id: entity.id,
    author: entity.author,
    title: entity.title,
    description: entity.description,
    url: entity.url,
    urlToImage: entity.urlToImage,
    publishedAt: entity.publishedAt,
    content: entity.content,
  );
}
