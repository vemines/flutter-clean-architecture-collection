import 'dart:io';

import 'package:flutter/material.dart';
import '../providers/pokemon_image_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/failure.dart';
import '../../business/entities/pokemon_image_entity.dart';

class PokemonImageWidget extends StatelessWidget {
  const PokemonImageWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    PokemonImageEntity? pokemonImageEntity =
        Provider.of<PokemonImageProvider>(context).pokemonImage;
    Failure? failure = Provider.of<PokemonImageProvider>(context).failure;
    late Widget widget;
    if (pokemonImageEntity != null) {
      widget = Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.orange,
            image: DecorationImage(image: FileImage(File(pokemonImageEntity.path))),
          ),
          child: child,
        ),
      );
    } else if (failure != null) {
      widget = Expanded(
        child: Center(child: Text(failure.errorMessage, style: TextStyle(fontSize: 20))),
      );
    } else {
      widget = Expanded(child: CircularProgressIndicator());
    }
    return widget;
  }
}
