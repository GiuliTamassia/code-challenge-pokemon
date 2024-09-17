import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class PokemonTitle extends StatelessWidget {
  final double fontSize;
  final int duration;

  const PokemonTitle({
    super.key,
    this.fontSize = 20,
    this.duration = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: AnimatedTextKit(
            animatedTexts: [
              WavyAnimatedText(
                'PoKéMoN',
                textStyle: TextStyle(
                  fontSize: fontSize,
                  fontFamily: 'Pokemon',
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 6
                    ..color = const Color.fromARGB(255, 59, 76, 202),
                ),
                speed: Duration(milliseconds: duration),
              ),
            ],
          ),
        ),
        Positioned(
          child: AnimatedTextKit(
            animatedTexts: [
              WavyAnimatedText(
                'PoKéMoN',
                textStyle: TextStyle(
                  fontSize: fontSize,
                  fontFamily: 'Pokemon',
                  color: const Color.fromARGB(255, 255, 222, 0),
                ),
                speed: Duration(milliseconds: duration),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
