import 'package:flutter/material.dart';

class WaitingPage extends StatefulWidget {
  const WaitingPage({Key? key}) : super(key: key);

  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..repeat();

    _animation1 = Tween(begin: 0.0, end: 8.0).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.33, curve: Curves.easeInOut),
    ));
    _animation2 = Tween(begin: 0.0, end: 8.0).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.33, 0.66, curve: Curves.easeInOut),
    ));
    _animation3 = Tween(begin: 0.0, end: 8.0).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.66, 1.0, curve: Curves.easeInOut),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(Animation<double> animation) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: AnimatedBuilder(
        animation: animation,
        builder: (_, child) => Container(
          width: 12,
          height: 12 + animation.value,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo asset
            Image.asset(
              'assets/images/logo.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(_animation1),
                _buildDot(_animation2),
                _buildDot(_animation3),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
