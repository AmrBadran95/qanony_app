import 'package:flutter/material.dart';
import 'package:qanony/Core/widgets/onboarding_screen.dart';

final List<Widget> onboardingPages = [
  OnboardingPage(
    text: 'أهلاً بك في دستورى',
    imagePath: 'assets/images/p1.png',
    paragraph:
        "منصتك القانونية الذكية. سواء كنت محامٍ أو باحث عن استشارة، كل الحلول القانونية بين إيديك",
  ),
  OnboardingPage(
    text: 'خدمات قانونية في متناولك',
    imagePath: 'assets/images/lawyer 1.png',
    paragraph: "اختَر محامي متخصص، اطلب خدمة، وتابع كل خطواتك من مكانك.",
  ),
  OnboardingPage(
    text: 'أمان وتنظيم في كل خطوة',
    imagePath: 'assets/images/court 1.png',
    paragraph: "احفظ مستنداتك، راجع معاملتك، وتواصل مع محاميك بثقة كاملة..",
  ),
];
