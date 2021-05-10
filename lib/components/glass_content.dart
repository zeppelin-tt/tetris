import 'package:flutter/material.dart';

class GlassContent extends StatelessWidget {
  final double glassHeight;
  final double rectSize;
  final Map<int, Color> glass;

  const GlassContent({
    required this.glassHeight,
    required this.rectSize,
    required this.glass,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: rectSize * 12,
      height: glassHeight,
      color: Colors.black,
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 12,
        children: List.generate(252, (index) {
          return glass[index] == Colors.white
              ? const SizedBox.shrink()
              : Center(
                  child: Container(
                    height: rectSize * .9,
                    width: rectSize * .9,
                    decoration: BoxDecoration(
                      color: glass[index],
                      borderRadius: BorderRadius.circular(rectSize * .9 * .12),
                    ),
                    // child: Center(
                    //   child: Text(
                    //     index.toString(),
                    //     style: TextStyale(color: Colors.yellow, fontSize: 11.0),
                    //   ),
                    // ),
                  ),
                );
        }),
      ),
    );
  }
}
