import 'package:flutter/material.dart';
import 'package:flutter_pokedex/components/pokemon_title.dart';
import 'package:flutter_pokedex/pages/pokedex.dart';
import 'dart:async';

class MyAnimation extends StatefulWidget {
  const MyAnimation({super.key});

  @override
  State<MyAnimation> createState() => _MyAnimationState();
}

class _MyAnimationState extends State<MyAnimation> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.15;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 204, 0, 0),
      body: Center(
        child: PokemonTitle(
          fontSize: fontSize,
          duration: 350,
        ),
      ),
    );
  }

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        CustomPageRoute(
          builder: (context) => const Overview(),
        ),
      );
    });
    super.initState();
  }
}

class CustomPageRoute extends MaterialPageRoute {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);

  CustomPageRoute({required super.builder});
}
