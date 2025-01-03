import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sipp_mobile/constant/colors.dart';
import 'package:sipp_mobile/injector.dart';
import 'package:sipp_mobile/provider/app_provider.dart';
import 'package:sipp_mobile/util/app_navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await registerDependency();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AppProvider()..getCurrentDate())
    ],
      builder: (context, child) => const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.light
      ..radius = 15.0
      ..backgroundColor = Colors.white
      ..indicatorColor = AppColor.purple
      ..textColor = Colors.yellow
      ..maskType = EasyLoadingMaskType.black
      ..userInteractions = false
      ..dismissOnTap = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: true,
      routeInformationProvider: AppNavigation.instance.route.routeInformationProvider,
      routeInformationParser: AppNavigation.instance.route.routeInformationParser,
      routerDelegate: AppNavigation.instance.route.routerDelegate,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primaryColor),
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      builder: EasyLoading.init(),
    );
  }
}