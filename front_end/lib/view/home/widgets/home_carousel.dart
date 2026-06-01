import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeCarousel extends StatefulWidget {
  const HomeCarousel({super.key});

  @override
  State<HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel> {
  final PageController _controller = PageController();

  Timer? _timer;
  Timer? _restartTimer;

  bool _isUserInteracting = false;

  final List<String> slides = const [
    'assets/images/slide_1.png',
    'assets/images/slide_2.png',
    'assets/images/slide_3.png',
    'assets/images/slide_4.png',
  ];

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_controller.hasClients) return;
      if (_isUserInteracting) return;

      int nextPage = currentPage + 1;

      if (nextPage >= slides.length) {
        nextPage = 0;
      }

      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _pauseAutoPlay() {
    _isUserInteracting = true;

    _timer?.cancel();
    _restartTimer?.cancel();

    _restartTimer = Timer(const Duration(seconds: 5), () {
      _isUserInteracting = false;
      _startAutoPlay();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _restartTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(
          height: size.height * 0.50,
          child: PageView.builder(
            controller: _controller,
            itemCount: slides.length,
            onPageChanged: (index) {
              _pauseAutoPlay();
              setState(() => currentPage = index);
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTapDown: (_) => _pauseAutoPlay(),
                onPanDown: (_) => _pauseAutoPlay(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Image.asset(
                      slides[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SmoothPageIndicator(
          controller: _controller,
          count: slides.length,
          effect: ExpandingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: _getColor(currentPage),
            dotColor: Colors.grey.shade300,
            expansionFactor: 3,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Color _getColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF3B82F6);
      case 1:
        return const Color(0xFFF97316);
      case 2:
        return const Color(0xFF22C55E);
      case 3:
        return const Color(0xFF7C3AED);
      default:
        return Colors.blue;
    }
  }
}
