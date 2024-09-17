import 'package:flutter/material.dart';
import 'package:flutter_pokedex/utils.dart';
import 'package:pokeapi_wrapper/pokeapi_wrapper.dart';

class DetailsPokemon extends StatefulWidget {
  final Pokemon pokemon;
  final Color? pokemonColor;

  final void Function()? onRemove;

  const DetailsPokemon(
      {super.key, required this.pokemon, this.pokemonColor, this.onRemove});

  @override
  State<DetailsPokemon> createState() => _DetailsPokemonState();
}

class _DetailsPokemonState extends State<DetailsPokemon> {
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontFamily: 'Classic',
    );
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Details',
            style: appBarTitleStyle,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(25),
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: widget.pokemonColor,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.black, width: 2.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Image.network(
                          widget.pokemon.sprites.officialArtWork,
                          height: 270,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              );
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Icon(Icons.error));
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ', style: textStyle),
                          SizedBox(height: 7),
                          Text(
                            'Name: ',
                            style: textStyle,
                          ),
                          SizedBox(height: 7),
                          Text('Height: ', style: textStyle),
                          SizedBox(height: 7),
                          Text('Weight: ', style: textStyle),
                          SizedBox(height: 7),
                          Text('Types: ', style: textStyle),
                          SizedBox(height: 7),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.pokemon.id.toString(), style: textStyle),
                          const SizedBox(height: 7),
                          Text(
                            widget.pokemon.name.toString(),
                            style: textStyle,
                          ),
                          const SizedBox(height: 7),
                          Text('${widget.pokemon.height} decimetres',
                              style: textStyle),
                          const SizedBox(height: 7),
                          Text('${widget.pokemon.weight} decigram',
                              style: textStyle),
                          const SizedBox(height: 7),
                          PokemonTypeText(pokemon: widget.pokemon),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (getCaptured().contains(widget.pokemon.id)) {
                        removeFromCaptured(widget.pokemon.id);
                        widget.onRemove?.call();
                      } else {
                        addToCaptured(widget.pokemon.id);
                      }
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: widget.pokemonColor ?? Colors.black,
                          width: 4.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          !(getCaptured().contains(widget.pokemon.id))
                              ? 'Add to captured'
                              : 'Remove from captured',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Classic',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DataPoint extends StatelessWidget {
  final String title;
  final String data;

  const DataPoint({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        Text(data),
      ],
    );
  }
}

class PokemonTypeText extends FutureBuilderWidget<List<Type>> {
  final Pokemon pokemon;

  const PokemonTypeText({super.key, required this.pokemon});

  @override
  Future<Either<Error, List<Type>>> get future => getTypes(pokemon);

  @override
  Widget onWaiting(BuildContext context) => const Text(
        'loading...',
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: 'Classic',
        ),
      );

  @override
  Widget onError(BuildContext context, Error error) =>
      Chip(label: Text('Error: ${error.toString()}'));

  @override
  Widget onSuccess(BuildContext context, List<Type> value) => Text(
        value.map((e) => e.name).join(', '),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: 'Classic',
        ),
      );
}
