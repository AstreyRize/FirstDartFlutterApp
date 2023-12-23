import 'package:flutter/material.dart';

class ControlStyle
{
  static Paint controlBorderLine () => Paint()
      ..color = const Color.fromARGB(50, 0, 0, 0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

  static Paint controlBackgroundFillColor () => Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

  static Paint iconBorderLine () => Paint()
      ..color = const Color.fromARGB(50, 0, 0, 0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

  static Paint iconFillColor () => Paint()
      ..color = const Color.fromARGB(0, 255, 255, 255)
      ..style = PaintingStyle.fill;

  static Paint waweFillColor () => Paint()
      ..color = const Color.fromARGB(255, 159, 166, 255)
      ..style = PaintingStyle.fill;
}

class PlayerButtonPainter extends CustomPainter {
  late double width = 50;
  late double height = 50;

  @override
  void paint(Canvas canvas, Size size) {
    final controlBorderLine = ControlStyle.controlBorderLine();
    final controlBackgroundFillColor = ControlStyle.controlBackgroundFillColor();
    final iconBorderLine = ControlStyle.iconBorderLine();
    final iconFillColor = ControlStyle.iconFillColor();

    canvas.drawCircle(Size(width, height).center(Offset.zero), width / 2.4, controlBackgroundFillColor);
    canvas.drawCircle(Size(width, height).center(Offset.zero), width / 2.4, controlBorderLine);
    
    var path = Path();
    path.moveTo(width * 0.4, height * 0.3);
    path.lineTo(width * 0.7, height * 0.5);
    path.lineTo(width * 0.4, height * 0.7);
    path.close();

    canvas.drawPath(path, iconFillColor);
    canvas.drawPath(path, iconBorderLine);
    // canvas.drawRect(Rect.fromLTRB(0, 0, width, height), line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class PlayerFieldPainter extends CustomPainter {
  final double width = 150;
  final double height = 30;
  late final double radius;

  PlayerFieldPainter() {
    radius = height / 2;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final controlBorderLine = ControlStyle.controlBorderLine();
    final controlBackgroundFillColor = ControlStyle.controlBackgroundFillColor();

    var path = Path();
    path.moveTo(radius, 0);
    path.lineTo(width - radius, 0);
    path.arcToPoint(
      Offset(width - radius, height),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    path.lineTo(radius, height);  
    path.arcToPoint(
      Offset(radius, 0),
      radius: Radius.circular(radius),
      clockwise: true,
    );

    canvas.drawPath(path, controlBackgroundFillColor);
    canvas.drawPath(path, controlBorderLine);
    // canvas.drawRect(Rect.fromLTRB(0, 0, width, height), line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class PlayerWavePainter extends CustomPainter {
  final int width = 150;
  final int height = 30;
  final int maxWaveAmp = 15;
  final double waveWidth = 3;
  final int waveStep = 3;
  final int waveStart = 35;
  late final double waweEnd = width - 7;
  late final int waveCount = ((waweEnd - waveStart) / (waveWidth + waveStep)).ceil();
  late final List<double> waveSizeNormolized;

  PlayerWavePainter({required List<double> waveSize}) {
    waveSizeNormolized = normolizeWave(waveSize);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    for(int i = 0; i < waveCount; i++) {
      double waveAmp = waveSizeNormolized[i] % maxWaveAmp;
      double wavePosition = waveStart + ((waveWidth + waveStep) * i);
      path.addRect(Rect.fromCenter(center: Offset(wavePosition, height / 2), width: waveWidth, height: waveAmp));
    }

    canvas.drawPath(path, ControlStyle.waweFillColor());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
  
  List<double> normolizeWave(List<double> waveSize) {
    var result = List<double>.filled(waveCount, 0);
    int chunkSize = waveSize.length > waveCount 
      ? (waveSize.length / waveCount).ceil()
      : 1;
    int chunkCount = (waveSize.length / chunkSize).ceil();

    for(int chunkPosition = 0; chunkPosition < chunkCount; chunkPosition++) {
      double chunkItemsValue = 0;
      for(int itemIndex = 0; itemIndex < chunkSize; itemIndex++) {
        int index = chunkPosition * chunkSize + itemIndex;

        if(index >= waveSize.length) {
          break;
        }

        chunkItemsValue += waveSize[index];
      }
      result[chunkPosition] = chunkItemsValue / chunkSize;
    }
    return result;
  }
}

class PlayerButton extends StatelessWidget {
  final VoidCallback onPressed;
  final List<double> waveSize;

  const PlayerButton({super.key, required this.onPressed, required this.waveSize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 20,
            top: 10,
            child: Stack(
              children: <Widget>[ 
                CustomPaint(
                  painter: PlayerFieldPainter(),
                  size: const Size(150, 50),
                ),
                CustomPaint(
                  painter: PlayerWavePainter(waveSize: waveSize),
                  size: const Size(150, 50),
                ),
              ]
            ),
          ),
          CustomPaint(
            painter: PlayerButtonPainter(),
            size: const Size(200, 50),
          ),
        ],
      ),
    );
  }
}