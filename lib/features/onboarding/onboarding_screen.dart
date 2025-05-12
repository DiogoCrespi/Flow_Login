import 'package:flutter/material.dart';
import '../../shared/widgets/animated_name_field.dart';
import '../../shared/widgets/theme_toggle_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Bem-vindo ao FlowLogin',
      description: 'Sua plataforma de login segura e intuitiva',
      imagePath: 'assets/images/onboarding1.png',
    ),
    OnboardingPage(
      title: 'Interface Moderna',
      description: 'Design limpo e responsivo para melhor experiência',
      imagePath: 'assets/images/onboarding2.png',
    ),
    OnboardingPage(
      title: 'Personalização',
      description: 'Digite seu nome para personalizar sua experiência',
      imagePath: 'assets/images/onboarding3.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem-vindo'),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          page.imagePath,
                          width: 120,
                          height: 120,
                        ),
                        const SizedBox(height: 32),
                        Text(
                          page.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        if (index == _pages.length - 1) ...[
                          const SizedBox(height: 32),
                          AnimatedNameField(
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, digite seu nome';
                              }
                              if (value.length < 3) {
                                return 'O nome deve ter pelo menos 3 caracteres';
                              }
                              return null;
                            },
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_currentPage == _pages.length - 1)
                    ElevatedButton(
                      onPressed: _goToLogin,
                      child: const Text('Começar'),
                    )
                  else
                    TextButton(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text('Próximo'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String imagePath;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}
