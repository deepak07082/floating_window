import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:floating_window_plus/floating_window_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Mini Player Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _parentKey = GlobalKey();

  final PipController _pipController = PipController(
    isSnaping: true,
    initialPosition:
        PipPosition(offset: Offset(0, 0), anchor: PipAnchor.custom),
    settings: PipSettings(
      collapsedWidth: 200,
      collapsedHeight: 120,
      expandedWidth: 350,
      expandedHeight: 280,
      borderRadius: BorderRadius.circular(16),
      backgroundColor: Colors.indigo,
      animationDuration: Duration(milliseconds: 400),
      animationCurve: Curves.easeOutQuart,
      snapToEdges: false,
    ),
  );

  void _toggleMiniPlayer() {
    _pipController.show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _parentKey,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.play_circle_filled, color: Colors.red),
            SizedBox(width: 8),
            Text('My Video App'),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Main content
          ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  width: 120,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(Icons.play_arrow, size: 30),
                  ),
                ),
                title: Text('Video ${index + 1}'),
                subtitle: Text('Duration: ${2 + index} mins'),
                onTap: _toggleMiniPlayer,
              );
            },
          ),
          PipPlayer(
            controller: _pipController,
            content: Container(
              color: Colors.amberAccent,
            ),
            onClose: () {
              _pipController.hide();
            },
            onExpand: () {
              _pipController.expand();
            },
            onTap: () {
              _pipController.toggleExpanded();
            },
          ),
          // Mini player
          // PiP player
        ],
      ),
    );
  }
}
