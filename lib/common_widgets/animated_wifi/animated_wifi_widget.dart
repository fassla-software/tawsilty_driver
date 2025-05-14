import 'package:flutter/material.dart';
import 'package:get/get.dart';
class WifiAnimations extends StatefulWidget {
  const WifiAnimations({super.key, this.size = 100, this.color = Colors.grey, this.centered = false});

  final double size;
  final bool centered;
  final Color color;

  @override
  WifiAnimationsState createState() => WifiAnimationsState();
}

class WifiAnimationsState extends State<WifiAnimations> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: List.generate(6, (index) {
                return Container(width: widget.size, height: widget.size,
                      padding: EdgeInsets.all(index * (widget.size / 10)),
                      child: ShapesState(
                        controller: _controller,
                        color: widget.color,
                        centered: widget.centered,
                        index: index,
                      ));
        }));
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ShapesState extends AnimatedWidget {
  const ShapesState({super.key, required this.index, required this.color, required this.centered, required AnimationController controller}) : super(listenable: controller);

  final int index;
  final bool centered;
  final Color color;

  Animation<double> get controller => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DrawShapes(index, color, centered, controller.value),
    );
  }
}

class DrawShapes extends CustomPainter {
  DrawShapes(this.index, this.color, this.centered, this.controller);

  final Color color;

  final bool centered;
  final int index;
  final double controller;

  @override
  void paint(Canvas canvas, Size size) {
    Color color = Theme.of(Get.context!).primaryColor.withOpacity(0.10);
    if ((4 - index) == ((controller * 5).toInt())) {
      color = Theme.of(Get.context!).primaryColor;
    }

    Paint brush =  Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    var startArc = (225 * 3.14) / 180;
    var endArc = (90 * 3.14) / 180;

    //make the first as a circle
    if (index == 0 && centered) {
      brush.style = PaintingStyle.fill;
      canvas.drawCircle(Offset(size.height / 2, size.width / 2), 5, brush);
    } else {
      brush.style = PaintingStyle.stroke;
      canvas.drawArc(Rect.fromCenter(center: Offset(size.height / 2, size.width / 2), height: size.height, width: size.width,), startArc, endArc, false, brush);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}