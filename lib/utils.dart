import 'package:flutter/material.dart';
import 'package:pokeapi_wrapper/pokeapi_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Either<Error, List<Pokemon>>> getPokemonEntities() async {
  final pokemonApiResources = await PokeApi.getPokemonList(limit: 151);

  if (pokemonApiResources.isLeft) {
    return Left(pokemonApiResources.left);
  }

  final futures = pokemonApiResources.right.map(
    (apiResource) => apiResource.getPokemon(),
  );

  final response = await Future.wait(futures);

  if (response.any((element) => element.isLeft)) {
    return Either.tryExcept(() => throw Error());
  }

  return Right(response.map((e) => e.right).toList());
}

Future<Either<Error, List<Type>>> getTypes(Pokemon pokemon) async {
  final futures = pokemon.types.map((e) => e.type);

  final response = await Future.wait(futures);

  if (response.any((element) => element.isLeft)) {
    return Either.tryExcept(() => throw Error());
  }

  return Right(response.map((e) => e.right).toList());
}

final Map<int, List<Type>> _pokemonTypeMapping = {};

Future<void> initPokemonTypeMapping() async {
  final pokemons = await getPokemonEntities();
  final types = pokemons.right
      .map(
        (pokemon) => getTypes(pokemon),
      )
      .toList();

  final response = await Future.wait(types);

  if (response.any((element) => element.isLeft)) {
    throw Error();
  }

  for (var i = 0; i < pokemons.right.length; i++) {
    _pokemonTypeMapping[pokemons.right[i].id] = response[i].right;
  }
}

bool checkIfSelected(Pokemon pokemon, Set<String> unselectedTypes) {
  return _pokemonTypeMapping[pokemon.id]?.any(
        (type) => !unselectedTypes.contains(type.name),
      ) ??
      true;
}

late final SharedPreferencesWithCache prefsWithCache;

Future<void> initStorage() async {
  prefsWithCache = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: <String>{capturedStr},
    ),
  );
}

const capturedStr = 'captured';

void addToCaptured(int id) async {
  final captured = prefsWithCache.getStringList(capturedStr) ?? [];

  captured.add(id.toString());
  captured.sort(
    (a, b) => int.parse(a).compareTo(int.parse(b)),
  );

  await prefsWithCache.setStringList(capturedStr, captured);
}

void removeFromCaptured(int id) async {
  final captured = prefsWithCache.getStringList(capturedStr) ?? [];

  captured.removeWhere((element) => element == id.toString());

  await prefsWithCache.setStringList(capturedStr, captured);
}

List<int> getCaptured() {
  return (prefsWithCache.getStringList(capturedStr) ?? [])
      .map((e) => int.parse(e))
      .toList();
}

String _getPokemonUrl(int id) {
  return 'https://pokeapi.co/api/v2/pokemon/$id/';
}

Future<Either<Error, List<Pokemon>>> fetchCapturedPokemon() async {
  final futures = getCaptured().map(
    (id) => PokeApi.getPokemon(PokemonApiResource(url: _getPokemonUrl(id))),
  );

  final response = await Future.wait(futures);

  if (response.any((element) => element.isLeft)) {
    return Either.tryExcept(() => throw Error());
  }

  return Right(response.map((e) => e.right).toList());
}

Future<Either<Error, Color>> getCapturedColor() async {
  final response = await fetchCapturedPokemon();

  if (response.isLeft) {
    return Left(response.left);
  }

  final types =
      await Future.wait(response.right.map((e) => e.types.first.type));

  if (types.any((element) => element.isLeft)) {
    return Either.tryExcept(() => throw Error());
  }

  final countTypes = <String, int>{};

  for (var type in types) {
    countTypes[type.right.name] = (countTypes[type.right.name] ?? 0) + 1;
  }

  final countList = countTypes.entries.toList();

  countList.sort(
    (a, b) => b.value.compareTo(a.value),
  );

  if (countList.isEmpty ||
      (countList.length >= 2 && countList[0].value == countList[1].value)) {
    return const Right(Color.fromARGB(255, 204, 0, 0));
  }

  return _getColorByName(countList[0].key);
}

Future<Either<Error, Color>> getPokemonColor(PokemonType pokemonType) async {
  final response = await pokemonType.type;

  if (response.isLeft) {
    return Left(response.left);
  }

  final type = response.right;

  return _getColorByName(type.name);
}

Either<Error, Color> _getColorByName(String name) {
  switch (name) {
    case "bug":
      return const Right(Color.fromARGB(0xFF, 0x94, 0xBC, 0x4A));
    case "dark":
      return const Right(Color.fromARGB(0xFF, 0x73, 0x6C, 0x75));
    case "dragon":
      return const Right(Color.fromARGB(0xFF, 0x6A, 0x7B, 0xAF));
    case "electric":
      return const Right(Color.fromARGB(0xFF, 0xE5, 0xC5, 0x31));
    case "fairy":
      return const Right(Color.fromARGB(0xFF, 0xE3, 0x97, 0xD1));
    case "fighting":
      return const Right(Color.fromARGB(0xFF, 0xCB, 0x5F, 0x48));
    case "fire":
      return const Right(Color.fromARGB(0xFF, 0xEA, 0x7A, 0x3C));
    case "flying":
      return const Right(Color.fromARGB(0xFF, 0x7D, 0xA6, 0xDE));
    case "ghost":
      return const Right(Color.fromARGB(0xFF, 0x84, 0x6A, 0xB6));
    case "grass":
      return const Right(Color.fromARGB(0xFF, 0x71, 0xC5, 0x58));
    case "ground":
      return const Right(Color.fromARGB(0xFF, 0xCC, 0x9F, 0x4F));
    case "ice":
      return const Right(Color.fromARGB(0xFF, 0x70, 0xCB, 0xD4));
    case "normal":
      return const Right(Color.fromARGB(0xFF, 0xAA, 0xB0, 0x9F));
    case "poison":
      return const Right(Color.fromARGB(0xFF, 0xB4, 0x68, 0xB7));
    case "psychic":
      return const Right(Color.fromARGB(0xFF, 0xE5, 0x70, 0x9B));
    case "rock":
      return const Right(Color.fromARGB(0xFF, 0xB2, 0xA0, 0x61));
    case "steel":
      return const Right(Color.fromARGB(0xFF, 0x89, 0xA1, 0xB0));
    case "water":
      return const Right(Color.fromARGB(0xFF, 0x53, 0x9A, 0xE2));
    default:
      return Either.tryExcept(
        () => throw Error(),
      );
  }
}

const appBarTitleStyle = TextStyle(
  fontFamily: 'Pokemon',
  color: Colors.black,
  fontSize: 35,
);
