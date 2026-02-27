import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import 'features/splash/splash_page.dart';
import 'features/hiring_tests/presentation/hiring_page.dart';
import 'features/hiring_tests/data/hiring_api.dart';
import 'features/hiring_tests/state/hiring_controller.dart';
import 'features/catalog/presentation/catalog_page.dart';
import 'features/profile/presentation/profile_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final dio = Dio(BaseOptions(baseUrl: 'https://monitoringinnovation.com/api/v1/hiring-tests'));
  final api = HiringApi(dio);

  runApp(MyApp(api: api));
}

class MyApp extends StatelessWidget {
  final HiringApi api;
  const MyApp({super.key, required this.api});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HiringController(api, cedula: '1000320178')..load(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Autos de lujo',
        theme: ThemeData(
          useMaterial3: true,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => const SplashPage(),
          HiringPage.routeName: (_) => const HiringPage(),
          CatalogPage.routeName: (_) => const CatalogPage(),
          ProfilePage.routeName: (_) => const ProfilePage(),
        },
      ),
    );
  }
}