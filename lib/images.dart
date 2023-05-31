import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImagesWidget extends ConsumerWidget {
  const ImagesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Return 4 images which can be dragged to swap positions
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Draggable(
          data: 0,
          child: Image.asset('assets/images/1.png'),
          feedback: Image.asset('assets/images/1.png'),
        ),
        Draggable(
          data: 1,
          child: Image.asset('assets/images/2.png'),
          feedback: Image.asset('assets/images/2.png'),
        ),
        Draggable(
          data: 2,
          child: Image.asset('assets/images/3.png'),
          feedback: Image.asset('assets/images/3.png'),
        ),
        Draggable(
          data: 3,
          child: Image.asset('assets/images/4.png'),
          feedback: Image.asset('assets/images/4.png'),
        ),
      ],
    );
  }
}