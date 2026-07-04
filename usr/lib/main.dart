import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const VideoEditorApp());
}

class VideoEditorApp extends StatelessWidget {
  const VideoEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blueAccent,
          secondary: Colors.tealAccent,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const VideoEditorScreen(),
      },
    );
  }
}

class VideoEditorScreen extends StatefulWidget {
  const VideoEditorScreen({super.key});

  @override
  State<VideoEditorScreen> createState() => _VideoEditorScreenState();
}

class _VideoEditorScreenState extends State<VideoEditorScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Using a standard sample video for preview purposes.
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'),
    )..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
      });

    _controller.addListener(() {
      setState(() {}); // Rebuild to update timeline
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {},
          tooltip: 'Close Project',
        ),
        title: const Text('New Project', style: TextStyle(fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: () {},
            tooltip: 'Undo',
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: () {},
            tooltip: 'Redo',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Export'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Video Preview Area
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: _isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          VideoPlayer(_controller),
                        ],
                      ),
                    )
                  : const CircularProgressIndicator(),
            ),
          ),
          
          // Playback Controls & Time
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: const Color(0xFF1E1E1E),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isInitialized
                      ? '${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}'
                      : '00:00 / 00:00',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.fast_rewind),
                      onPressed: () {
                        if (_isInitialized) {
                          _controller.seekTo(
                            _controller.value.position - const Duration(seconds: 5),
                          );
                        }
                      },
                      color: Colors.white,
                    ),
                    IconButton(
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        size: 36,
                      ),
                      onPressed: _isInitialized ? _togglePlayPause : null,
                      color: Colors.white,
                    ),
                    IconButton(
                      icon: const Icon(Icons.fast_forward),
                      onPressed: () {
                        if (_isInitialized) {
                          _controller.seekTo(
                            _controller.value.position + const Duration(seconds: 5),
                          );
                        }
                      },
                      color: Colors.white,
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.fullscreen),
                  onPressed: () {},
                  color: Colors.white,
                ),
              ],
            ),
          ),

          // Timeline Area
          Expanded(
            flex: 3,
            child: Container(
              color: const Color(0xFF121212),
              child: Column(
                children: [
                  // Timeline Ruler (Mock)
                  Container(
                    height: 24,
                    width: double.infinity,
                    color: const Color(0xFF1A1A1A),
                    child: CustomPaint(
                      painter: _TimelineRulerPainter(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Video Track (Mock)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blueAccent, width: 2),
                      ),
                      child: Row(
                        children: [
                          Container(width: 10, color: Colors.blueAccent),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 40,
                                  margin: const EdgeInsets.all(2),
                                  color: Colors.black26,
                                  child: const Icon(Icons.image, size: 20, color: Colors.white24),
                                );
                              },
                            ),
                          ),
                          Container(width: 10, color: Colors.blueAccent),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Audio Track (Mock)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.teal, width: 1),
                      ),
                      child: const Center(
                        child: Text(
                          'Audio Track.mp3',
                          style: TextStyle(color: Colors.teal, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tools Area
          Container(
            height: 80,
            color: const Color(0xFF1E1E1E),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              children: [
                _buildToolItem(Icons.cut, 'Edit'),
                _buildToolItem(Icons.music_note, 'Audio'),
                _buildToolItem(Icons.text_fields, 'Text'),
                _buildToolItem(Icons.filter_b_and_w, 'Filters'),
                _buildToolItem(Icons.auto_awesome, 'Effects'),
                _buildToolItem(Icons.speed, 'Speed'),
                _buildToolItem(Icons.format_size, 'Ratio'),
                _buildToolItem(Icons.color_lens, 'Adjust'),
                _buildToolItem(Icons.photo_filter, 'Overlay'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _TimelineRulerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1;
    
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    double spacing = 20.0;
    for (double i = 0; i < size.width; i += spacing) {
      bool isMajor = (i % (spacing * 5)) == 0;
      double height = isMajor ? 12.0 : 6.0;
      canvas.drawLine(Offset(i, 0), Offset(i, height), paint);

      if (isMajor && i > 0) {
        textPainter.text = TextSpan(
          text: '${(i / spacing).round()}s',
          style: const TextStyle(color: Colors.white54, fontSize: 8),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(i - textPainter.width / 2, height + 2));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
