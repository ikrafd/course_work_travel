import 'package:flutter/material.dart';

class PointWidget extends StatelessWidget {
  final bool showTopLine;
  final bool showBottomLine;
  final Color color;

  const PointWidget({
    super.key,
    this.showTopLine = false,
    this.showBottomLine = false,
    this.color = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    const double lineHeight = 100.0; 
    const double pointRadius = 6.0; 

    return SizedBox(
      height: 200, 
      child: Stack(
        alignment: Alignment.center, 
        children: [
          if (showTopLine)
            Positioned(
              top: 0,
              child: Container(
                width: 2,
                height: lineHeight,
                color: color,
              ),
            ),
          Center(
            child: CircleAvatar(
              radius: pointRadius,
              backgroundColor: color,
            ),
          ),
          if (showBottomLine)
            Positioned(
              bottom: 0,
              child: Container(
                width: 2,
                height: lineHeight,
                color: color,
              ),
            ),
        ],
      ),
    );
  }
}
