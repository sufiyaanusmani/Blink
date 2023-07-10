import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:food_delivery/main.dart';


Future<void> saveToSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isviewed', true);
}


void navigateToMainScreen(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => FoodDelivery(),
    ),
  );
}


class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'title 1',
      'description':
          'Aute et et ullamco ad veniam in sunt occaecat magna labore.',
      'imagePath': 'assets/onboarding/onboarding1.png',
    },
    {
      'title': 'title 2',
      'description':
          'Aute et et ullamco ad veniam in sunt occaecat magna labore.',
      'imagePath': 'assets/onboarding/onboarding2.png',
    },
    {
      'title': 'title 3',
      'description':
          'Aute et et ullamco ad veniam in sunt occaecat magna labore.',
      'imagePath': 'assets/onboarding/onboarding3.png',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _onboardingData.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return buildOnboardingPage(
                      _onboardingData[index]['title']!,
                      _onboardingData[index]['description']!,
                      _onboardingData[index]['imagePath']!,
                    );
                  },
                ),
              ),
              if (_currentPage == 2)
                Positioned(
                  top: 40,
                  right: 16,
                  child: FilledButton(
                    onPressed: () {
                      // handle homescreen


                    },
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 47, 47, 47))),
                    child: Text('Get Started'),
                  )
                ),
              SizedBox(height: 30),              
              SmoothPageIndicator(
                controller: _pageController,
                count: _onboardingData.length,
                effect: const WormEffect(
                  dotHeight: 16,
                  dotWidth: 16,
                  type: WormType.normal,
                  dotColor: Colors.black26,
                  activeDotColor: Colors.black,
                ),
              ),
              SizedBox(height: 70),
            ],
          ),
          Positioned(
            top: 40,
            right: 16,
            child: GestureDetector(
              onTap: () async {
                // handle homescreen


              },
              child: Image.asset(
                'assets/icons/cancel.png',
                width: 32,
                height: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOnboardingPage(
      String title, String description, String imagePath) {
    final desiredWidth = MediaQuery.of(context).size.width;
    final desiredHeight = MediaQuery.of(context).size.height * 0.55;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Image.asset(
            imagePath,
            width: desiredWidth,
            height: desiredHeight,
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(height: 30),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
