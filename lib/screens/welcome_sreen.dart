import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Simulate loading progress
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _simulateLoading();
    });
  }

  Future<void> _simulateLoading() async {
    while (_progress < 1.0) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _progress += 0.05; // Increment progress
      });
    }
    // Navigate to the next screen after loading
    // Example: Navigator.of(context).pushReplacementNamed('/home');
    await Future.delayed(const Duration(seconds: 1));
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shopping_cart,
                    size: 70,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 20),
                // Welcome Text
                Text(
                  'Welcome to ShopEasy',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                // Description Text
                Text(
                  'Your one-stop shop for everything!',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40),
                // Loading Indicator
                CustomLoader(progress: _progress),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomLoader extends StatelessWidget {
  final double progress;

  const CustomLoader({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Loading Line
        Container(
          width: 250,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        // Animated Golden Pointer
        Positioned(
          left: (250 * progress) - 10,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber,
              boxShadow: [
                BoxShadow(
                  color: Colors.amberAccent.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Sparkles(),
          ),
        ),
      ],
    );
 }
}

class Sparkles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        // Spark Animation
        Positioned(
          top: 0,
          left: 0,
          child: Icon(
            Icons.star,
            color: Colors.yellow,
            size: 10,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Icon(
            Icons.star,
            color: Colors.yellow,
            size: 10,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Icon(
            Icons.star,
            color: Colors.yellow,
            size: 10,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Icon(
            Icons.star,
            color: Colors.yellow,
            size: 10,
          ),
        ),
      ],
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: GoogleFonts.poppins()),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text('Welcome to Home Screen', style: GoogleFonts.poppins(fontSize: 20)),
      ),
    );
  }
}