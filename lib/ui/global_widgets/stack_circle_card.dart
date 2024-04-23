import 'package:flutter/material.dart';

import '../theme/color_theme.dart';

class StackCicleCard extends StatelessWidget {
  const StackCicleCard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          right: -30,
          top: 30,
          child: CircleCard(),
        ),
        const Positioned(
          right: 140,
          top: 30,
          child: CircleCard(
            height: 40,
            width: 40,
          ),
        ),
        const Positioned(
          left: -10,
          bottom: 50,
          child: CircleCard(
            height: 80,
            width: 80,
          ),
        ),
        const Positioned(
          left: 50,
          bottom: 140,
          child: CircleCard(
            height: 25,
            width: 25,
          ),
        ),
        Align(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: child,
          ),
        ),
      ],
    );
  }
}

class CircleCard extends StatelessWidget {
  const CircleCard({
    super.key,
    this.height,
    this.width,
    this.radius,
  });

  final double? height;
  final double? width;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 150,
      width: width ?? 150,
      decoration: BoxDecoration(
        color: pinkColorOpacit5,
        borderRadius: BorderRadius.circular(radius ?? height ?? 150),
      ),
    );
  }
}
