import 'package:flutter/material.dart';
import 'package:flutter_pokedex/components/filter_dialog.dart';
import 'package:flutter_pokedex/components/menu.dart';
import 'package:flutter_pokedex/components/pokemon_title.dart';
import 'package:flutter_pokedex/pages/pokedex.dart';
import 'package:flutter_pokedex/utils.dart';
import 'package:pokeapi_wrapper/pokeapi_wrapper.dart';

class Captured extends StatefulWidget {
  const Captured({super.key});

  @override
  State<Captured> createState() => _CapturedState();
}

enum SortType {
  id,
  alphanumeric,
}

class _CapturedState extends State<Captured> {
  SortType _sortType = SortType.id;
  Color _appBarColor = const Color.fromARGB(255, 204, 0, 0);
  Set<String> _unselectedTypes = {};

  @override
  void initState() {
    super.initState();
    _calculateAppBarColor();
  }

  void _calculateAppBarColor() {
    getCapturedColor().then(
      (color) {
        setState(() {
          if (color.isRight) {
            _appBarColor = color.right;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _appBarColor,
        title: const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: PokemonTitle(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'Captured',
              style: appBarTitleStyle,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  showDialog<Set<String>?>(
                    context: context,
                    builder: (context) => FilterDialog(
                      unselectedTypes: _unselectedTypes,
                    ),
                  ).then((result) {
                    if (result == null) {
                      return;
                    }
                    setState(() {
                      _unselectedTypes = result;
                    });
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: 36,
                  decoration: BoxDecoration(
                      color:
                          _unselectedTypes.isEmpty ? Colors.grey : Colors.black,
                      borderRadius: BorderRadius.circular(5)),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.filter_list_alt,
                        size: 25,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => setState(() {
                  if (_sortType == SortType.alphanumeric) {
                    _sortType = SortType.id;
                    return;
                  }
                  _sortType = SortType.alphanumeric;
                }),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: 36,
                  decoration: BoxDecoration(
                      color: _sortType == SortType.alphanumeric
                          ? Colors.black
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(5)),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.sort_by_alpha,
                        size: 25,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          Expanded(
            child: CapturedBody(
              onRemove: () {
                _calculateAppBarColor();
                setState(() {});
              },
              sortType: _sortType,
              unselectedTypes: _unselectedTypes,
            ),
          ),
        ],
      ),
      floatingActionButton: Hero(
        tag: 'ball',
        child: RotatingPokeballMenu(
          onTap: () {
            Navigator.of(context).pop();
          },
          rotateRight: false,
        ),
      ),
    );
  }
}

class CapturedBody extends FutureBuilderWidget<List<Pokemon>> {
  final void Function() onRemove;
  final SortType sortType;
  final Set<String> unselectedTypes;
  const CapturedBody(
      {super.key,
      required this.onRemove,
      required this.sortType,
      required this.unselectedTypes});

  @override
  Future<Either<Error, List<Pokemon>>> get future => fetchCapturedPokemon();

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
    if (sortType == SortType.alphanumeric) {
      value.sort((a, b) => a.name.compareTo(b.name));
    }

    final list = value
        .where((element) => checkIfSelected(element, unselectedTypes))
        .toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) => OverviewPokemon(
        pokemon: list[index],
        onRemove: onRemove,
      ),
    );
  }
}

class CapturedColorBar extends FutureBuilderWidget<Color> {
  final Widget child;
  const CapturedColorBar({super.key, required this.child});

  @override
  Future<Either<Error, Color>> get future => getCapturedColor();

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
  Widget onSuccess(BuildContext context, Color value) {
    return AppBar(
      title: child,
      backgroundColor: value,
    );
  }
}
