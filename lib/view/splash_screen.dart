import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sipp_mobile/constant/app_constant.dart';
import 'package:sipp_mobile/constant/textstyles.dart';
import 'package:sipp_mobile/provider/splash_provider.dart';
import 'package:sipp_mobile/util/app_navigation.dart';
import 'package:sipp_mobile/view/login/login_screen.dart';

import 'dashboard/bottom_nav_bar.dart';

class SplashBase extends StatelessWidget {
  const SplashBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          SplashProvider provider = SplashProvider();
          EasyLoading.show();
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
            bool login = await provider.hasLogin();
            if(login) {
              EasyLoading.dismiss();
              AppNavigation.instance.neglect(path: AppConstant.dashboardRoute);
            } else {
              EasyLoading.dismiss();
              AppNavigation.instance.neglect(path: AppConstant.loginRoute);
            }
          });
          return provider;
        },
      child: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            left: -100,
            top: -87,
            child: Image.asset('assets/images/general/round-bg-icon.png'),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/general/app-icon.png'),
                      const SizedBox(height: 31,),
                      Text("APLIKASI PENGHITUNGAN POHON", style: AppTextStyle.bold24Black,),
                      Text("APLIKASI PENGHITUNGAN POHON", style: AppTextStyle.regular14Black,),
                    ],
                  ),
                ),
                Selector<SplashProvider, bool>(
                  selector: (p0, provider) => provider.hasLoginValue,
                    builder: (context, value, child) {
                      return Text("Selamat Datang", style: AppTextStyle.regular14Black, textAlign: TextAlign.center,);
                    },
                ),
                const SizedBox(height: 24,)
              ],
            ),
          ),
          Positioned(
            right: -100,
            bottom: -87,
            child: Image.asset('assets/images/general/round-bg-icon.png'),
          ),
        ],
      ),
    );
  }
}
