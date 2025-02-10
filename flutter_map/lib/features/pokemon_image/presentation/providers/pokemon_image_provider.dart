import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../../../pokemon/business/entities/pokemon_entity.dart';
import '../../business/entities/pokemon_image_entity.dart';
import '../../business/usecases/get_pokemon_image.dart';
import '../../data/datasources/pokemon_image_local_data_source.dart';
import '../../data/datasources/pokemon_image_remote_data_source.dart';
import '../../data/repositories/pokemon_image_repository_impl.dart';

class PokemonImageProvider extends ChangeNotifier {
  PokemonImageEntity? pokemonImage;
  Failure? failure;

  PokemonImageProvider({this.pokemonImage, this.failure});

  void eitherFailureOrPokemonImage({required PokemonEntity pokemonEntity}) async {
    PokemonImageRepositoryImpl repository = PokemonImageRepositoryImpl(
      remoteDataSource: PokemonImageRemoteDataSourceImpl(dio: Dio()),
      localDataSource: PokemonImageLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(InternetConnection()),
    );

    String imageUrl =
        isShiny
            ? pokemonEntity.sprites.other.officialArtwork.frontShiny
            : pokemonEntity.sprites.other.officialArtwork.frontDefault;

    final failureOrPokemonImage = await GetPokemonImage(
      pokemonImageRepository: repository,
    ).call(pokemonImageParams: PokemonImageParams(name: pokemonEntity.name, imageUrl: imageUrl));

    failureOrPokemonImage.fold(
      (Failure newFailure) {
        pokemonImage = null;
        failure = newFailure;
        notifyListeners();
      },
      (PokemonImageEntity newPokemonImage) {
        pokemonImage = newPokemonImage;
        failure = null;
        notifyListeners();
      },
    );
  }
}
