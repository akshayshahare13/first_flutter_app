import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

/// Global settings model for the app.
class AppSettings {
  int numberOfLevels;
  bool soundOn;
  bool celebrationOn;
  double shapeSize; // logical pixels for shape size
  AppSettings({
    this.numberOfLevels = 5,
    this.soundOn = true,
    this.celebrationOn = true,
    this.shapeSize = 80.0,
  });
}

// Global settings instance (with default values)
AppSettings appSettings = AppSettings();

/// Main App widget. Routes include HomePage, SettingsPage, and GamePage.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autism Education App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      home: HomePage(),
      routes: {
        '/settings': (context) => SettingsPage(),
        '/game': (context) => GamePage(),
      },
    );
  }
}

/// HomePage uses the JPG background image and custom button icons.
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a Stack to display a full-screen background image with overlay.
      body: Stack(
        children: [
          // Background image.
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/homepage_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay.
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
          // Main content: Centered custom icon buttons.
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Start Game Button using custom icon.
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/game');
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/button_start.png',
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Start Game',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // White text color
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Settings Button using custom icon.
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/button_settings.png',
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // White text color
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// SettingsPage allows the user to configure levels, sound, celebration, and shape sizes.
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}
class _SettingsPageState extends State<SettingsPage> {
  late int numberOfLevels;
  late bool soundOn;
  late bool celebrationOn;
  late double shapeSize;
  String shapeSizeLabel = "Medium"; // default

  @override
  void initState() {
    super.initState();
    numberOfLevels = appSettings.numberOfLevels;
    soundOn = appSettings.soundOn;
    celebrationOn = appSettings.celebrationOn;
    shapeSize = appSettings.shapeSize;
    shapeSizeLabel = shapeSize == 60 ? "Small" : shapeSize == 80 ? "Medium" : "Large";
  }

  void updateShapeSize(String value) {
    setState(() {
      shapeSizeLabel = value;
      if (value == "Small") {
        shapeSize = 60;
      } else if (value == "Medium") {
        shapeSize = 80;
      } else if (value == "Large") {
        shapeSize = 100;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      backgroundColor: Colors.blueGrey[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Number of Levels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Number of Levels:'),
                DropdownButton<int>(
                  value: numberOfLevels,
                  items: [3, 4, 5, 6, 7]
                      .map((e) => DropdownMenuItem<int>(
                            value: e,
                            child: Text(e.toString()),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      numberOfLevels = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            // Sound toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sound:'),
                Switch(
                  value: soundOn,
                  onChanged: (val) {
                    setState(() {
                      soundOn = val;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            // Celebration toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Celebration:'),
                Switch(
                  value: celebrationOn,
                  onChanged: (val) {
                    setState(() {
                      celebrationOn = val;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            // Shape size selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Shape Size:'),
                DropdownButton<String>(
                  value: shapeSizeLabel,
                  items: ["Small", "Medium", "Large"]
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (val) {
                    updateShapeSize(val!);
                  },
                ),
              ],
            ),
            SizedBox(height: 32),
            ElevatedButton(
              child: Text('Save Settings'),
              onPressed: () {
                // Save settings globally
                appSettings.numberOfLevels = numberOfLevels;
                appSettings.soundOn = soundOn;
                appSettings.celebrationOn = celebrationOn;
                appSettings.shapeSize = shapeSize;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Define available shape types.
enum ShapeType { circle, star, square, rectangle, triangle }

/// Mapping of shape types to colors.
final Map<ShapeType, Color> shapeColors = {
  ShapeType.circle: Colors.blue,
  ShapeType.star: Colors.yellow,
  ShapeType.square: Colors.red,
  ShapeType.rectangle: Colors.green,
  ShapeType.triangle: Colors.purple,
};

/// Data model for each game item (a draggable shape and its drop target).
class GameItem {
  final ShapeType shape;
  final Offset draggablePosition;
  final Offset targetPosition;
  bool isDropped;
  GameItem({
    required this.shape,
    required this.draggablePosition,
    required this.targetPosition,
    this.isDropped = false,
  });
}

/// GamePage displays the draggable shapes and drop targets with modern styling.
class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}
class _GamePageState extends State<GamePage> {
  int currentLevel = 1;
  late int maxLevel; // from settings
  List<GameItem> gameItems = [];
  bool levelComplete = false;
  AudioPlayer audioPlayer = AudioPlayer();
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    maxLevel = appSettings.numberOfLevels;
    setupLevel();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  /// Sets up the level by generating non-overlapping positions for draggables and targets.
  void setupLevel() {
    setState(() {
      levelComplete = false;
    });
    gameItems.clear();

    List<ShapeType> availableShapes = ShapeType.values.toList();
    int itemCount = currentLevel;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      double gameAreaWidth = size.width;
      double gameAreaHeight = size.height - kToolbarHeight - 40;
      double topAreaHeight = gameAreaHeight * 0.4;
      double bottomAreaHeight = gameAreaHeight * 0.4;
      double draggableAreaTop = 20;
      double targetAreaTop = draggableAreaTop + topAreaHeight + 20;
      double shapeSize = appSettings.shapeSize;
      double targetSize = shapeSize * 1.2; // targets are slightly bigger

      List<Offset> draggablePositions = generateRandomPositions(
          itemCount, gameAreaWidth, topAreaHeight, shapeSize);
      List<Offset> targetPositions = generateRandomPositions(
          itemCount, gameAreaWidth, bottomAreaHeight, targetSize);

      List<GameItem> items = [];
      for (int i = 0; i < itemCount; i++) {
        ShapeType shape = availableShapes[i % availableShapes.length];
        Offset draggablePos = Offset(
            draggablePositions[i].dx, draggablePositions[i].dy + draggableAreaTop);
        Offset targetPos = Offset(
            targetPositions[i].dx, targetPositions[i].dy + targetAreaTop);
        items.add(GameItem(
          shape: shape,
          draggablePosition: draggablePos,
          targetPosition: targetPos,
        ));
      }
      setState(() {
        gameItems = items;
      });
    });
  }

  /// Generates random positions ensuring no overlap.
  List<Offset> generateRandomPositions(
      int count, double areaWidth, double areaHeight, double itemSize) {
    List<Offset> positions = [];
    int attempts = 0;
    while (positions.length < count && attempts < 1000) {
      double x = random.nextDouble() * (areaWidth - itemSize);
      double y = random.nextDouble() * (areaHeight - itemSize);
      Offset newPos = Offset(x, y);
      bool overlaps = false;
      for (Offset pos in positions) {
        if ((newPos - pos).distance < itemSize + 20) {
          overlaps = true;
          break;
        }
      }
      if (!overlaps) {
        positions.add(newPos);
      }
      attempts++;
    }
    return positions;
  }

  /// Checks if all items have been correctly dropped.
  void checkLevelComplete() {
    if (gameItems.every((item) => item.isDropped)) {
      setState(() {
        levelComplete = true;
      });
      if (appSettings.soundOn) {
        playCelebrationSound();
      }
    }
  }

  /// Plays the celebration sound.
  void playCelebrationSound() async {
    await audioPlayer.play(AssetSource('sounds/celebration.wav'));
  }

  /// Advances to the next level or returns to the homepage if finished.
  void nextLevelOrExit() {
    if (currentLevel < maxLevel) {
      setState(() {
        currentLevel++;
      });
      setupLevel();
    } else {
      Navigator.popUntil(context, ModalRoute.withName('/'));
    }
  }

  /// Resets the current level.
  void resetLevel() {
    setState(() {
      for (var item in gameItems) {
        item.isDropped = false;
      }
      levelComplete = false;
    });
    setupLevel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use the same background image as the home page.
      body: Stack(
        children: [
          // Background image.
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/homepage_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay to ensure contrast.
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
          // Main game content.
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text('Level $currentLevel'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: resetLevel,
                    tooltip: 'Reset Level',
                  ),
                ],
              ),
              Expanded(
                child: Stack(
                  children: [
                    // Draggable shapes and drop targets.
                    Positioned.fill(
                      child: Stack(
                        children: [
                          // Draggable shapes.
                          ...gameItems.map((item) {
                            return Positioned(
                              left: item.draggablePosition.dx,
                              top: item.draggablePosition.dy,
                              child: item.isDropped
                                  ? Container(width: appSettings.shapeSize, height: appSettings.shapeSize)
                                  : Draggable<ShapeType>(
                                      data: item.shape,
                                      feedback: buildShapeWidget(item.shape, opacity: 0.5),
                                      childWhenDragging: buildShapeWidget(item.shape, opacity: 0.3),
                                      child: buildShapeWidget(item.shape),
                                    ),
                            );
                          }).toList(),
                          // Drop targets.
                          ...gameItems.map((item) {
                            return Positioned(
                              left: item.targetPosition.dx,
                              top: item.targetPosition.dy,
                              child: DragTarget<ShapeType>(
                                onWillAccept: (data) => !item.isDropped,
                                onAccept: (data) {
                                  if (data == item.shape) {
                                    setState(() {
                                      item.isDropped = true;
                                    });
                                    checkLevelComplete();
                                  }
                                },
                                builder: (context, candidateData, rejectedData) {
                                  return buildTargetWidget(item.shape, item.isDropped);
                                },
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    // Celebration overlay when level is complete.
                    if (levelComplete)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black45,
                          child: Stack(
                            children: [
                              // Full-screen animated celebration GIF.
                              Positioned.fill(
                                child: Image.asset(
                                  'assets/animations/celebration_balloon.gif',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Overlay with Good Job text and button.
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      color: Colors.black.withOpacity(0.5),
                                      child: Text(
                                      'Good job!',
                                      style: TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: nextLevelOrExit,
                                      child: Text(currentLevel < maxLevel ? 'Next Level' : 'Exit Game'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a draggable shape widget with soft corners and glowing effects.
  Widget buildShapeWidget(ShapeType shape, {double opacity = 1.0}) {
    double size = appSettings.shapeSize;
    Color color = shapeColors[shape]!.withOpacity(opacity);
    switch (shape) {
      case ShapeType.circle:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [BoxShadow(color: color, blurRadius: 10, spreadRadius: 2)],
          ),
        );
      case ShapeType.star:
        return Icon(
          Icons.star,
          size: size,
          color: color,
          shadows: [Shadow(color: color, blurRadius: 10)],
        );
      case ShapeType.square:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: color, blurRadius: 10, spreadRadius: 2)],
          ),
        );
      case ShapeType.rectangle:
        return Container(
          width: size * 1.2,
          height: size * 0.8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: color, blurRadius: 10, spreadRadius: 2)],
          ),
        );
      case ShapeType.triangle:
        return CustomPaint(
          size: Size(size, size),
          painter: TrianglePainter(color),
        );
      default:
        return Container();
    }
  }

  /// Builds a drop target widget with a glowing outline and soft edges.
  Widget buildTargetWidget(ShapeType shape, bool isCompleted) {
    double size = appSettings.shapeSize * 1.2;
    Color color = shapeColors[shape]!;
    switch (shape) {
      case ShapeType.circle:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? color.withOpacity(0.5) : Colors.transparent,
            border: Border.all(color: color, width: 3),
            boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)],
          ),
        );
      case ShapeType.star:
        return Icon(
          isCompleted ? Icons.star : Icons.star_border,
          size: size,
          color: color,
          shadows: [Shadow(color: color.withOpacity(0.5), blurRadius: 10)],
        );
      case ShapeType.square:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isCompleted ? color.withOpacity(0.5) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: 3),
            boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)],
          ),
        );
      case ShapeType.rectangle:
        return Container(
          width: size * 1.2,
          height: size * 0.8,
          decoration: BoxDecoration(
            color: isCompleted ? color.withOpacity(0.5) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: 3),
            boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)],
          ),
        );
      case ShapeType.triangle:
        return CustomPaint(
          size: Size(size, size),
          painter: TriangleOutlinePainter(color, isCompleted),
        );
      default:
        return Container();
    }
  }
}

/// Custom painter for a filled triangle with soft, rounded edges.
class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.quadraticBezierTo(0, size.height * 0.8, 0, size.height);
    path.quadraticBezierTo(size.width / 2, size.height * 0.9, size.width, size.height);
    path.quadraticBezierTo(size.width, size.height * 0.8, size.width / 2, 0);
    path.close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(TrianglePainter oldDelegate) => false;
}

/// Custom painter for an outlined triangle target with soft edges.
class TriangleOutlinePainter extends CustomPainter {
  final Color color;
  final bool isFilled;
  TriangleOutlinePainter(this.color, this.isFilled);
  @override
  void paint(Canvas canvas, Size size) {
    Paint fillPaint = Paint()
      ..color = isFilled ? color.withOpacity(0.5) : Colors.transparent
      ..style = PaintingStyle.fill;
    Paint strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.quadraticBezierTo(0, size.height * 0.8, 0, size.height);
    path.quadraticBezierTo(size.width / 2, size.height * 0.9, size.width, size.height);
    path.quadraticBezierTo(size.width, size.height * 0.8, size.width / 2, 0);
    path.close();
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }
  @override
  bool shouldRepaint(TriangleOutlinePainter oldDelegate) => false;
}
