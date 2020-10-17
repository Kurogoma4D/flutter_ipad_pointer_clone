import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

@immutable
class PointerAdaptiveWidgetOptions {
  final double hitAreaSize;
  final Rect widgetRect;

  PointerAdaptiveWidgetOptions({this.hitAreaSize, this.widgetRect});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Color(0xFFFFFCDC)),
          const PointerCanvas(),
        ],
      ),
    );
  }
}

class PointerCanvas extends StatefulWidget {
  const PointerCanvas({Key key}) : super(key: key);

  @override
  _PointerCanvasState createState() => _PointerCanvasState();
}

class _PointerCanvasState extends State<PointerCanvas> {
  Offset pointerCoordination = Offset.zero;

  void setCoordination(PointerHoverEvent event) {
    setState(() => pointerCoordination = event.position);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: setCoordination,
      child: RepaintBoundary(
        child: CustomPaint(
          painter: PointerPainter(pointerCoordination),
          size: MediaQuery.of(context).size,
        ),
      ),
    );
  }
}

class PointerPainter extends CustomPainter {
  final Offset realPointer;
  static final _realPointerPaint = Paint()
    ..color = Colors.grey.withOpacity(0.7)
    ..style = PaintingStyle.fill;
  static final _realPointerRadius = 16.0;
  PointerPainter(this.realPointer);

  final target = PointerAdaptiveWidgetOptions(
    hitAreaSize: 32,
    widgetRect: Rect.fromLTWH(300, 300, 240, 120),
  );

  @override
  void paint(Canvas canvas, Size size) {
    /// draw target (temporary)
    drawTarget(canvas);

    /// draw real pointer
    canvas.drawCircle(realPointer, _realPointerRadius, _realPointerPaint);
  }

  void drawTarget(Canvas canvas) {
    final p = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.fill;
    final vp = Paint()
      ..color = Colors.greenAccent.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(target.widgetRect, Radius.circular(8)), vp);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            target.widgetRect.deflate(target.hitAreaSize), Radius.circular(8)),
        p);
  }

  @override
  bool shouldRepaint(covariant PointerPainter oldDelegate) =>
      oldDelegate.realPointer != realPointer;
}
