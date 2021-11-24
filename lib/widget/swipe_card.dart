import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grupolaranja20212/provider/card_provider.dart';

class SwipeCard extends StatefulWidget {
  final String urlImage;
  final bool isFront;

  const SwipeCard({
    Key? key,
    required this.urlImage,
    required this.isFront,
  }) : super(key: key);

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      final provider = Provider.of<CardProvider>(
        context,
        listen: false,
      );
      provider.setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) => SizedBox.expand(
        child: widget.isFront ? buildFrontCard() : buildCard(),
      );

  Widget buildFrontCard() => GestureDetector(
        child: LayoutBuilder(builder: (context, constraints) {
          final provider = Provider.of<CardProvider>(context);
          final position = provider.position;
          final milliseconds = provider.isDragging ? 0 : 300;

          final center = constraints.smallest.center(Offset.zero);
          final angle = provider.angle * pi / 180;
          final rotateMatrix = Matrix4.identity()
            ..translate(center.dx, center.dy)
            ..rotateZ(angle)
            ..translate(-center.dx, -center.dy);

          return AnimatedContainer(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: milliseconds),
            transform: rotateMatrix..translate(position.dx, position.dy),
            child: Stack(children: [
              buildCard(),
              buildStamps(),
            ]),
          );
        }),
        onPanStart: (details) {
          final provider = Provider.of<CardProvider>(
            context,
            listen: false,
          );

          provider.startPosition(details);
        },
        onPanUpdate: (details) {
          final provider = Provider.of<CardProvider>(
            context,
            listen: false,
          );

          provider.updatePosition(details);
        },
        onPanEnd: (details) {
          final provider = Provider.of<CardProvider>(
            context,
            listen: false,
          );

          provider.endPosition();
        },
      );

  Widget buildCard() => ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.urlImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black],
                  stops: [0.7, 1])),
        ),
      ));

  Widget buildStamps() {
    final provider = Provider.of<CardProvider>(context, listen: false);
    final status = provider.getStatus();
    final opacity = provider.getStatusOpacity();

    switch (status) {
      case CardStatus.like:
        final child = buildStamp(
          angle: -0.5,
          color: Colors.green,
          text: 'LIKE',
          opacity: opacity,
        );

        return Positioned(top: 64, left: 50, child: child);
      case CardStatus.dislike:
        final child = buildStamp(
          angle: 0.5,
          color: Colors.red,
          text: 'DISLIKE',
          opacity: opacity,
        );

        return Positioned(top: 64, right: 50, child: child);
      case CardStatus.skip:
        final child = Center(
            child: buildStamp(
          color: Colors.lightBlue,
          text: 'SKIP',
          opacity: opacity,
        ));

        return Positioned(bottom: 64, right: 0, left: 0, child: child);
      default:
        return Container();
    }
  }

  Widget buildStamp({
    double angle = 0,
    required Color color,
    required String text,
    required double opacity,
  }) {
    return Opacity(
        opacity: opacity,
        child: Transform.rotate(
            angle: angle,
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color, width: 4),
                ),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ))));
  }
}
