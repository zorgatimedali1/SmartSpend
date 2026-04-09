// lib/shared/widgets/loading_widget.dart
// ignore_for_file: duplicate_ignore, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.surface,
        highlightColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: ListView(padding: const EdgeInsets.all(16), children: [
          const SizedBox(height: 16),
          // ignore: prefer_const_literals_to_create_immutables, prefer_const_constructors
          Row(children: [
            Expanded(child: _Box(90)),
            const SizedBox(width: 12),
            Expanded(child: _Box(90)),
          ]),
          const SizedBox(height: 16),
          _Box(220), const SizedBox(height: 16), _Box(180),
          const SizedBox(height: 16),
          ...List.generate(
              4,
              (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 10), child: _Box(70))),
        ]),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  final double h;
  const _Box(this.h);
  @override
  Widget build(BuildContext context) => Container(
      height: h,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)));
}

class ShimmerBox extends StatelessWidget {
  final double width, height;
  final double radius;
  const ShimmerBox(
      {super.key, required this.width, required this.height, this.radius = 8});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.surface,
        highlightColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(radius))),
      );
}
