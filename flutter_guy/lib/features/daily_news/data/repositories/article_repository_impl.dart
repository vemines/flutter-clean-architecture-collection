import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/resources/data_state.dart';
import '../data_sources/remote/news_api_service.dart';
import '../data_sources/local/app_database.dart';
import '../models/article.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;
  final AppDatabase _appDatabase;

  // ArticleRepositoryImpl(this._newsApiService);
  ArticleRepositoryImpl(this._newsApiService, this._appDatabase);

  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
    try {
      final httpResponse = await _newsApiService.getNewsArticles(
        apiKey: newsApiKey,
        country: countryQuery,
        category: categoryQuery,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data.articles);
      } else {
        return DataFailure(
          DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioExceptionType.badResponse,
            requestOptions: httpResponse.response.requestOptions,
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailure(e);
    }
  }

  @override
  Future<List<ArticleModel>> getSavedArticles() => _appDatabase.articleDao.getArticles();

  @override
  Future<void> removeArticle(ArticleEntity article) =>
      _appDatabase.articleDao.deleteArticle(ArticleModel.fromEntity(article));

  @override
  Future<void> saveArticle(ArticleEntity article) =>
      _appDatabase.articleDao.insertArticle(ArticleModel.fromEntity(article));
}
