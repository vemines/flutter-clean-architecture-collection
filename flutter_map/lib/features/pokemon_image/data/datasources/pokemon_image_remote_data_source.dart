import 'dart:io';

import 'package:dio/dio.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/params/params.dart';
import '../../../../core/constants/constants.dart';
import '../models/pokemon_image_model.dart';
import 'package:path_provider/path_provider.dart';

abstract class PokemonImageRemoteDataSource {
  Future<PokemonImageModel> getPokemonImage({required PokemonImageParams pokemonImageParams});
}

class PokemonImageRemoteDataSourceImpl implements PokemonImageRemoteDataSource {
  final Dio dio;

  PokemonImageRemoteDataSourceImpl({required this.dio});

  @override
  Future<PokemonImageModel> getPokemonImage({
    required PokemonImageParams pokemonImageParams,
  }) async {
    Directory directory = await getApplicationDocumentsDirectory();
    directory.deleteSync(recursive: true);

    final String pathFile = '${directory.path}/${pokemonImageParams.name}.png';

    final response = await dio.download(pokemonImageParams.imageUrl, pathFile);

    if (response.statusCode == 200) {
      return PokemonImageModel.fromJson(json: {kPath: pathFile});
    } else {
      throw ServerException();
    }
  }
}
