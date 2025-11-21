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
    Navigator.of(context);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => SettingsPage(),
      ),
    );
  }

  Widget _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < slides.length; i++) {
      indicators.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indicators,
    );
  }

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
    const englishSelected = SnackBar(
      content: Text('English is selected for the interface language of this introduction!'),
    );
    const indonesiaSelected = SnackBar(
      content: Text('Bahasa Indonesia menjadi bahasa antar muka pengantar ini!'),
    );
    final Color color = Theme.of(context).colorScheme.primary;
    var brightness = View.of(context).platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return SlideTile(
                    imagePath: slides[index].imageAssetPath,
                    title: slides[index].title,
                    description: slides[index].description,
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // English
                TextButton(
                  onPressed: () {
                    context.setLocale(Locale('en'));
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(englishSelected);
                  },
                  child: Text(
                    'english'.tr(),
                    style: TextStyle(color: isDarkMode ? color : Color(0xff121298)),
                  ),
                ),
                const SizedBox(width: 8.0),
                Text('|'),
                const SizedBox(width: 8.0),
                // Indonesia
                TextButton(
                  onPressed: () {
                    context.setLocale(Locale('id'));
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(indonesiaSelected);
                  },
                  child: Text(
                    'indonesia'.tr(),
                    style: TextStyle(color: isDarkMode ? color : Color(0xff9b00a1)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildPageIndicator(),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage < slides.length - 1)
                    ElevatedButton(
                      onPressed: _onDone,
                      child: Text("skip").tr(),
                    ),
                  if (_currentPage == slides.length - 1)
                    ElevatedButton(
                      onPressed: _onDone,
                      child: Text("done").tr(),
                    ),
                  if (_currentPage < slides.length - 1)
                    ElevatedButton(
                      onPressed: () {
                        _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      child: Text("next").tr(),
                    ),
                ],
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class SlideTile extends StatelessWidget {
  final String imagePath, title, description;
  const SlideTile(
      {super.key,
        required this.imagePath,
        required this.title,
        required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath),
          SizedBox(height: 20),
          Text(title.tr(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          SizedBox(height: 10),
          Text(description.tr(), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}