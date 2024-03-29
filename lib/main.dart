import 'package:flutter/material.dart';
import 'package:svg_clickable/extensions/path_pointer.dart';
import 'package:touchable/touchable.dart';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:path_drawing/path_drawing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(child: WorldMap()),
    );
  }
}

class WorldMap extends StatelessWidget {
  final notifier = ValueNotifier(Offset.zero);

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) => notifier.value = e.localPosition,
      onPointerMove: (e) => notifier.value = e.localPosition,
      child: CustomPaint(
        painter: WorldMapPainter(notifier),
        child: SizedBox.expand(),
      ),
    );
  }
}

class Shape {
  Shape(strPath, this._label, this._color) : _path = parseSvgPathData(strPath);

  /// transforms a [_path] into [_transformedPath] using given [matrix]
  void transform(Matrix4 matrix) =>
      _transformedPath = _path.transform(matrix.storage);

  final Path _path;
  late Path _transformedPath;
  final String _label;
  final Color _color;
}

class WorldMapPainter extends CustomPainter {
  WorldMapPainter(this._notifier) : super(repaint: _notifier);

  static final _data =
      '''m 247.031,209.282 -34.356,-5.153 c -1.383,-0.212 -2.799,-0.047 -4.097,0.466 l -22.403,8.843 c -2.456,0.97 -4.263,3.087 -4.835,5.664 l -4.38,19.712 c -0.621,2.791 0.314,5.713 2.439,7.624 l 10.325,9.294 c 1.665,1.498 3.893,2.222 6.122,1.996 l 19.936,-2.109 0.574,29.839 c 0.014,0.731 0.129,1.455 0.34,2.151 l 3.636,12 c 2.232,7.368 8.905,12.318 16.604,12.318 6.49,0 12.385,-3.575 15.385,-9.33 l 27.542,-52.836 c 1.64,-3.145 0.978,-7.037 -1.61,-9.464 l -3.589,-3.364 z
m 251.751,140.12 -17.579,-9.057 c -1.12,-0.576 -2.376,-0.881 -3.634,-0.881 -2.187,0 -4.3,0.915 -5.794,2.51 l -16.302,17.388 c -2.068,2.206 -2.704,5.34 -1.658,8.177 l 2.943,7.884 -10.435,9.887 -9.946,5.759 c -2.84,1.645 -4.361,4.805 -3.873,8.051 l 0.831,5.539 c 0.578,3.856 3.955,6.766 7.854,6.765 1.125,0 2.221,-0.236 3.257,-0.702 l 8.502,-3.827 10.604,-4.494 10.86,7.602 c 0.921,0.646 1.948,1.081 3.047,1.292 l 16.603,3.165 z
m 352.346,231.706 7.955,-0.378 c 2.06,-0.099 3.976,-0.979 5.394,-2.48 l 8.351,-8.842 c 2.28,-2.414 2.815,-6.032 1.329,-9.003 l -5.843,-11.564 12.973,-7.983 c 1.674,-1.03 2.901,-2.637 3.456,-4.521 l 5.253,-17.86 c 1.133,-3.855 -0.797,-7.955 -4.49,-9.538 l -7.879,-3.326 1.049,-6.1 9.008,-3.793 c 2.151,-0.904 3.788,-2.7 4.491,-4.927 l 1.269,-4.014 10.367,12.253 c 1.516,1.791 3.712,2.818 6.026,2.818 4.398,0 7.976,-3.565 7.976,-7.948 l -0.001,-13.994 -0.322,-15.146 c -0.214,-10.079 -8.578,-18.279 -18.645,-18.279 -0.747,0 -1.504,0.045 -2.25,0.135 l -77.435,9.292 0.531,-1.442 c 0.876,-2.378 0.558,-5.056 -0.852,-7.161 -1.409,-2.106 -3.763,-3.422 -6.294,-3.519 l -9.848,-0.379 c -2.599,-0.09 -5.105,1.101 -6.658,3.17 l -24.181,32.253 -21.325,10.69 -4.72,65.058 0,4.104 27.633,27.651 5.584,-1.861 c 2.629,-0.877 4.58,-3.012 5.216,-5.709 0.637,-2.697 -0.153,-5.479 -2.113,-7.438 l -8.196,-8.117 0.544,-0.688 17.154,11.061 13.818,19.96 c 1.483,2.143 3.921,3.421 6.523,3.421 2.989,0 5.696,-1.649 7.064,-4.304 l 6.159,-12.105 13.825,9.823 c 1.362,0.968 2.948,1.48 4.585,1.48 2.357,-10e-4 4.585,-1.043 6.114,-2.861 1.498,-1.781 2.126,-4.133 1.723,-6.452 z
m 422.31,296.3 -9.319,-17.706 c -1.377,-2.616 -4.071,-4.241 -7.03,-4.241 -2.629,0 -5.073,1.293 -6.558,3.468 l -2.432,-3.04 c -1.515,-1.894 -3.775,-2.979 -6.202,-2.979 -1.437,0 -2.849,0.391 -4.083,1.132 l -22.045,13.227 c -2.104,1.261 -3.526,3.47 -3.805,5.907 l -1.877,16.424 c -0.256,2.246 0.459,4.5 1.962,6.185 1.726,1.935 4.28,2.921 6.912,2.594 l 18.67,-2.377 2.958,7.025 c 1.242,2.952 4.114,4.859 7.316,4.859 l 0.001,0 c 0.455,0 0.913,-0.04 1.362,-0.118 l 10.25,-1.782 c 2.514,-0.435 4.678,-2.068 5.79,-4.365 l 8.253,-17.056 c 1.091,-2.259 1.046,-4.935 -0.123,-7.157 z
m 153.469,265.01 -37.698,-24.424 c -2.067,-1.339 -4.459,-2.047 -6.916,-2.047 -3.966,0 -7.648,1.844 -10.051,4.947 l -4.5,6.65 -4.611,6.916 c -1.646,2.469 -1.782,5.619 -0.355,8.222 l 9.663,17.604 -1.26,42.85 c -0.054,1.834 0.534,3.643 1.658,5.096 l 7.795,10.067 c 1.52,1.963 3.793,3.089 6.239,3.089 2.157,0 4.255,-0.882 5.756,-2.419 1.485,-1.521 2.274,-3.552 2.222,-5.719 l -0.358,-14.23 29.281,-28.035 c 1.052,-1.008 1.806,-2.283 2.18,-3.689 l 4.311,-16.166 c 0.888,-3.334 -0.46,-6.834 -3.356,-8.712 z
m 98.804,243.486 -8.455,-4.733 -15.1,-21.496 7.702,0 c 1.836,0 3.627,-0.642 5.043,-1.807 l 28.637,-23.547 15.938,-9.032 c 1.94,-1.1 3.336,-2.977 3.829,-5.151 0.494,-2.175 0.045,-4.471 -1.231,-6.301 l -14.111,-20.227 c -1.531,-2.193 -4.057,-3.468 -6.713,-3.395 -2.673,0.067 -5.115,1.462 -6.532,3.729 l -7.273,11.782 -8.339,-9.378 16.573,-12.187 c 3.068,-2.257 4.102,-6.388 2.459,-9.822 l -4.086,-8.545 c -0.953,-1.992 -2.709,-3.509 -4.818,-4.161 -2.11,-0.653 -4.415,-0.391 -6.323,0.715 L 88.78,124.14 56.134,110.327 32.686,97.102 c -2.844,-1.604 -6.443,-1.283 -8.957,0.795 L 11.31,108.156 c -1.091,0.901 -1.923,2.08 -2.405,3.408 l -8.429,23.181 c -0.871,2.393 -0.534,5.079 0.9,7.185 1.435,2.105 3.811,3.4 6.358,3.467 l 17.89,0.422 11.355,28.074 -1.854,27.803 c -0.112,1.684 0.327,3.394 1.238,4.814 l 15.267,23.815 c 0.919,1.435 2.248,2.517 3.845,3.131 l 29.367,11.24 c 0.266,0.254 0.562,0.465 0.876,0.633 l 8.586,4.807 z
m 136.06,107.943 4.304,3.261 0,39.436 c 0,4.382 3.567,7.947 7.951,7.947 1.535,0 3.034,-0.45 4.335,-1.302 l 27.258,-17.822 c 1.707,-1.116 2.906,-2.823 3.378,-4.806 l 9.091,-38.182 c 0.678,-2.85 -0.261,-5.828 -2.45,-7.773 l -8.403,-7.47 c -2.229,-1.982 -5.52,-2.545 -8.282,-1.414 l -35.365,14.468 c -2.666,1.09 -4.485,3.446 -4.865,6.301 -0.38,2.855 0.759,5.605 3.048,7.356 z'''
          .split('\n');

  final _shapes = [
    Shape(_data[0], 'africa', Colors.grey),
    Shape(_data[1], 'europe', Colors.green),
    Shape(_data[2], 'asia', Colors.lightGreen),
    Shape(_data[3], 'australia', Colors.orange),
    Shape(_data[4], 'south america', Colors.red),
    Shape(_data[5], 'north america', Colors.indigo),
    Shape(_data[6], 'here are dragons...', Colors.white),
  ];

  final ValueNotifier<Offset> _notifier;
  final Paint _paint = Paint();
  Size _size = Size.zero;

  @override
  void paint(Canvas canvas, Size size) {
    if (size != _size) {
      _size = size;
      final fs = applyBoxFit(BoxFit.contain, Size(423.22101, 423.22101), size);
      final r = Alignment.center.inscribe(fs.destination, Offset.zero & size);
      final matrix = Matrix4.translationValues(r.left, r.top, 0)
        ..scale(fs.destination.width / fs.source.width);
      for (var shape in _shapes) {
        shape.transform(matrix);
      }
      print('new size: $_size');
    }

    canvas
      ..clipRect(Offset.zero & size)
      ..drawColor(Colors.blueGrey, BlendMode.src);
    var selectedShape;
    for (var shape in _shapes) {
      final path = shape._transformedPath;
      final selected = path.contains(_notifier.value);
      _paint
        ..color = selected ? Colors.teal : shape._color
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, _paint);
      selectedShape ??= selected ? shape : null;

      _paint
        ..color = Colors.black
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, _paint);
    }
    if (selectedShape != null) {
      _paint
        ..color = Colors.black
        ..maskFilter = MaskFilter.blur(BlurStyle.outer, 12)
        ..style = PaintingStyle.fill;
      canvas.drawPath(selectedShape._transformedPath, _paint);
      _paint.maskFilter = null;

      final builder = ui.ParagraphBuilder(ui.ParagraphStyle(
        fontSize: 32,
        fontFamily: 'Roboto',
      ))
        ..pushStyle(ui.TextStyle(
          color: Colors.white70,
          // shadows: kElevationToShadow[1] + kElevationToShadow[2],
        ))
        ..addText(selectedShape._label);
      final paragraph = builder.build()
        ..layout(ui.ParagraphConstraints(width: size.width));
      canvas.drawParagraph(paragraph, _notifier.value.translate(0, -32));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
