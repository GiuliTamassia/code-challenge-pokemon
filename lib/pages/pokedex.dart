import 'package:flutter/material.dart';
import 'package:flutter_pokedex/components/pokemon_title.dart';
import 'package:flutter_pokedex/pages/Captured.dart';
import 'package:flutter_pokedex/pages/details.dart';
import 'package:flutter_pokedex/utils.dart';
import 'package:pokeapi_wrapper/pokeapi_wrapper.dart';
import 'package:flutter_pokedex/components/menu.dart';

// use of pokeapi_wrapper 0.0.3 (https://pub.dev/packages/pokeapi_wrapper)

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  String _searchTerm = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: PokemonTitle(),
        ),
        backgroundColor: const Color.fromARGB(255, 204, 0, 0),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Pokédex',
            style: appBarTitleStyle,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search Pokémon...',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(child: OverviewBody(searchTerm: _searchTerm)),
        ],
      ),
      floatingActionButton: Hero(
        tag: 'ball',
        child: RotatingPokeballMenu(onTap: () {
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Captured(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
            },
          ));
        }),
      ),
    );
  }
}

class OverviewBody extends FutureBuilderWidget<List<Pokemon>> {
  final String searchTerm;

  const OverviewBody({super.key, required this.searchTerm});

  @override
  Future<Either<Error, List<Pokemon>>> get future => getPokemonEntities();

  @override
  Widget onWaiting(BuildContext context) => const SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );

  @override
  Widget onError(BuildContext context, Error error) =>
      Text('Error: ${error.toString()}');

  @override
  Widget onSuccess(BuildContext context, List<Pokemon> value) {
    final filtered =
        value.where((pokemon) => pokemon.name.contains(searchTerm)).toList();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) => OverviewPokemon(
        pokemon: filtered[index],
      ),
    );
  }
}

class OverviewPokemon extends StatelessWidget {
  final Pokemon pokemon;
  final void Function()? onRemove;
  const OverviewPokemon({super.key, required this.pokemon, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return OverviewPokemonSpecies(pokemon: pokemon, onRemove: onRemove);
  }
}

class OverviewPokemonSpecies extends FutureBuilderWidget<PokemonSpecies> {
  final Pokemon pokemon;
  final void Function()? onRemove;
  const OverviewPokemonSpecies(
      {super.key, required this.pokemon, this.onRemove});

  @override
  Future<Either<Error, PokemonSpecies>> get future => pokemon.species;

  @override
  Widget onWaiting(BuildContext context) => Container(color: Colors.white);

  @override
  Widget onError(BuildContext context, Error error) =>
      Container(color: Colors.white);

  @override
  Widget onSuccess(BuildContext context, PokemonSpecies value) =>
      OverviewPokemonColor(
          pokemon: pokemon, pokemonSpecies: value, onRemove: onRemove);
}

class OverviewPokemonColor extends FutureBuilderWidget<Color> {
  final Pokemon pokemon;
  final PokemonSpecies pokemonSpecies;
  final void Function()? onRemove;
  const OverviewPokemonColor(
      {super.key,
      required this.pokemon,
      required this.pokemonSpecies,
      required this.onRemove});

  @override
  Future<Either<Error, Color>> get future =>
      getPokemonColor(pokemon.types.first);

  @override
  Widget onWaiting(BuildContext context) => Container(color: Colors.white);

  @override
  Widget onError(BuildContext context, Error error) =>
      Container(color: Colors.red, child: Text(error.toString()));

  @override
  Widget onSuccess(BuildContext context, Color value) => GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  DetailsPokemon(
                pokemon: pokemon,
                pokemonColor: value,
                onRemove: onRemove,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(position: offsetAnimation, child: child);
              },
            ),
          );
        },
        child: Card(
          color: value,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Flexible(child: Image.network(pokemon.sprites.officialArtWork)),
                Text(pokemon.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(
                  height: 8,
                ),
                Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: pokemon.types
                        .map((pokemonType) =>
                            OverviewAbilityChip(pokemonType: pokemonType))
                        .toList()),
              ],
            ),
          ),
        ),
      );
}

class OverviewAbilityChip extends FutureBuilderWidget<Type> {
  final PokemonType pokemonType;
  const OverviewAbilityChip({super.key, required this.pokemonType});

  @override
  Future<Either<Error, Type>> get future => pokemonType.type;

  @override
  Widget onWaiting(BuildContext context) =>
      const Chip(label: CircularProgressIndicator());

  @override
  Widget onError(BuildContext context, Error error) =>
      Chip(label: Text('Error: ${error.toString()}'));

  @override
  Widget onSuccess(BuildContext context, Type value) =>
      Chip(label: Text(value.name));
}
