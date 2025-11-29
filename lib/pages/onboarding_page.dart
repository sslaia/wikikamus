import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikikamus/pages/settings_page.dart';
import '../models/slider_model.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  OnboardingPageState createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {
  late PageController _pageController;
  int _currentPage = 0;
  late List<SliderModel> slides;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    slides = getSlides();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (context) => SettingsPage()),
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            final slide = slides[_currentPage];
            if (orientation == Orientation.landscape) {
              return LandscapeLayout(
                pageController: _pageController,
                onPageChanged: _onPageChanged,
                slides: slides,
                currentPage: _currentPage,
                onDone: _onDone,
                currentSlide: slide,
              );
            } else {
              return PortraitLayout(
                pageController: _pageController,
                onPageChanged: _onPageChanged,
                slides: slides,
                currentPage: _currentPage,
                onDone: _onDone,
              );
            }
          },
        ),
      ),
    );
  }
}

class PortraitLayout extends StatelessWidget {
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final List<SliderModel> slides;
  final int currentPage;
  final VoidCallback onDone;

  const PortraitLayout({
    super.key,
    required this.pageController,
    required this.onPageChanged,
    required this.slides,
    required this.currentPage,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: pageController,
            itemCount: slides.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              return SlideTile(
                imagePath: slides[index].imageAssetPath,
                title: slides[index].title,
                description: slides[index].description,
              );
            },
          ),
        ),
        OnboardingControls(
          currentPage: currentPage,
          slidesCount: slides.length,
          pageController: pageController,
          onDone: onDone,
        ),
      ],
    );
  }
}

class LandscapeLayout extends StatelessWidget {
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final List<SliderModel> slides;
  final int currentPage;
  final VoidCallback onDone;
  final SliderModel currentSlide;

  const LandscapeLayout({
    super.key,
    required this.pageController,
    required this.onPageChanged,
    required this.slides,
    required this.currentPage,
    required this.onDone,
    required this.currentSlide,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: slides.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        final slide = slides[index];
        return Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Image.asset(slide.imageAssetPath, fit: BoxFit.contain),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          slide.title.tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            slide.description.tr(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  OnboardingControls(
                    currentPage: currentPage,
                    slidesCount: slides.length,
                    pageController: pageController,
                    onDone: onDone,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class OnboardingControls extends StatelessWidget {
  final int currentPage;
  final int slidesCount;
  final PageController pageController;
  final VoidCallback onDone;

  const OnboardingControls({
    super.key,
    required this.currentPage,
    required this.slidesCount,
    required this.pageController,
    required this.onDone,
  });

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.deepPurple : Colors.grey[400],
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => context.setLocale(const Locale('en')),
              child: Text(
                'english'.tr(),
                style: TextStyle(
                  color: isDarkMode ? color : const Color(0xff121298),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            const Text('|'),
            const SizedBox(width: 8.0),
            TextButton(
              onPressed: () => context.setLocale(const Locale('id')),
              child: Text(
                'indonesia'.tr(),
                style: TextStyle(
                  color: isDarkMode ? color : const Color(0xff9b00a1),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            slidesCount,
            (index) => _indicator(index == currentPage),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentPage < slidesCount - 1)
                ElevatedButton(onPressed: onDone, child: Text("skip".tr())),
              if (currentPage == slidesCount - 1)
                const Spacer(), // Use Spacer to push "done" button to the right
              ElevatedButton(
                onPressed: () {
                  if (currentPage < slidesCount - 1) {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  } else {
                    onDone();
                  }
                },
                child: Text(
                  currentPage < slidesCount - 1 ? "next".tr() : "done".tr(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

class SlideTile extends StatelessWidget {
  final String imagePath, title, description;
  const SlideTile({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath),
          SizedBox(height: 16),
          Text(
            title.tr(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            description.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
