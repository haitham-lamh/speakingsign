import 'package:get/get.dart';
import 'package:speaking_sign/binding/keyboard/key_binding.dart';
import 'package:speaking_sign/binding/keyboard/keyboard_binding.dart';
import 'package:speaking_sign/binding/onboarding/onbording_binding.dart';
import 'package:speaking_sign/binding/setting/aboout_app/about_binding.dart';
import 'package:speaking_sign/binding/splash/splash_binding.dart';
import 'package:speaking_sign/presentation/screens/Keyboard/keyboard_view.dart';
import 'package:speaking_sign/presentation/screens/Onbording/onbording_view.dart';
import 'package:speaking_sign/presentation/screens/Keyboard/key_view.dart';
import 'package:speaking_sign/presentation/screens/settings/About_App/about_view.dart';
import 'package:speaking_sign/presentation/screens/settings/Proposals/Proposals_view.dart';
import 'package:speaking_sign/presentation/screens/settings/camera/camera.dart';
import 'package:speaking_sign/presentation/screens/settings/conction_theglavs/conctiontheglavs.dart';
import 'package:speaking_sign/presentation/screens/splash/splash_view.dart';
import 'package:speaking_sign/presentation/screens/word_detaile/word_detaile_view.dart';
import 'package:speaking_sign/presentation/widgets/custom_curved_bottom_navigation_bar.dart';
import 'package:speaking_sign/routes/app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.KEYBOARD,
      page: () => Keyboard(),
      binding: KeyboardBinding(),
    ),
    GetPage(
      name: AppRoutes.HomeView,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.ABOUTAPP,
      page: () => AboutView(),
      binding: AbpoutViewBinding(),
    ),
    GetPage(
      name: AppRoutes.CustomCurvedBottomNavigationBar,
      page: () => CustomCurvedBottomNavigationBar(),
    ),
    GetPage(name: AppRoutes.WordDetaileView, page: () => WordDetaileView()),
    GetPage(name: AppRoutes.ProposalsView, page: () => ProposalsView()),

    GetPage(name: AppRoutes.Conctiontheglavs, page: () => Conctiontheglavs()),
    GetPage(name: AppRoutes.Camera, page: () => Camera()),

  ];
}
