import 'package:flutter/material.dart';
import 'package:flutter_pokedex/pages/Captured.dart';
import 'package:flutter_pokedex/pages/pokedex.dart';
import 'package:flutter_pokedex/pages/startanimation.dart';
import 'utils.dart';

/* ***************************************************************************

Pokedex App Code Challenge

von Giuliana Tamassia (17.09.2024)

*************************************************************************** */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initStorage();
  await initPokemonTypeMapping();
  runApp(const Pokedex());
}

class Pokedex extends StatelessWidget {
  const Pokedex({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyAnimation(),
      routes: {
        '/animation': (context) => const MyAnimation(),
        '/overview': (context) => const Overview(),
        '/captured': (context) => const Captured(),
      },
    );
  }
}
