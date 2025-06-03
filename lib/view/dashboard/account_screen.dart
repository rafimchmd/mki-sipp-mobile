import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:sipp_mobile/component/button/base_button.dart';
import 'package:sipp_mobile/component/input/base_input.dart';
import 'package:sipp_mobile/component/other/snackbar.dart';
import 'package:sipp_mobile/constant/app_constant.dart';
import 'package:sipp_mobile/enums/button_style.dart';
import 'package:sipp_mobile/provider/auth/auth_provider.dart';
import 'package:sipp_mobile/repository/auth/auth_repo.dart';
import 'package:sipp_mobile/util/app_navigation.dart';
import 'package:sipp_mobile/view/dashboard/widget/header_widget.dart';
import 'package:sipp_mobile/view/login/login_screen.dart';

import '../../constant/textstyles.dart';
import '../../injector.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        AuthProvider provider = AuthProvider(locator<AuthRepo>());
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          await provider.loadProfile();
        });
        return provider;
      } ,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.grey[35],
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: 600,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 7,
                            spreadRadius: 5,
                            offset: const Offset(0, 1)
                        )
                      ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16,),
                        Row(
                          children: [
                            Text("APLIKASI PENGHITUNGAN POHON", style: AppTextStyle.bold14Black,),
                            const SizedBox(width: 8,),
                            const Icon(Icons.lock, size: 16, color: Colors.grey,)
                          ],
                        ),
                        const SizedBox(height: 12,),
                        Text("Data Pribadi", style: AppTextStyle.regular12Black,),
                        const SizedBox(height: 24,),
                        Selector<AuthProvider, String?>(
                          selector: (p0, provider) => provider.name,
                          builder: (context, name, child) {
                            return BaseInput(
                                enabled: false,
                                controller: TextEditingController(),
                                fillColor: Colors.grey[100],
                                hint: name ?? "-"
                            );
                            },
                        ),
                        const SizedBox(height: 16,),
                        Selector<AuthProvider, String?>(
                          selector: (p0, provider) => provider.email,
                          builder: (context, email, child) {
                            return BaseInput(
                                enabled: false,
                                controller: TextEditingController(),
                                fillColor: Colors.grey[100],
                                hint: email ?? "-"
                            );
                          },
                        ),
                        const SizedBox(height: 24,),
                        Consumer<AuthProvider>(
                          builder: (context, provider, child) {
                            return BaseButton(
                                buttonStyle: AppButtonStyle.redFilled,
                                onPressed: () async {
                                  await context.read<AuthProvider>().logout();
                                  if(provider.logoutResponse?.code == 200) {
                                    FirebaseAnalytics.instance.logEvent(name: "Logout_Success");
                                    AppNavigation.instance.neglect(path: AppConstant.loginRoute);
                                  } else {
                                    EasyLoading.dismiss();
                                    FirebaseAnalytics.instance.logEvent(name: "Logout_Failed", parameters: {
                                      "error_code": provider.logoutResponse?.code
                                    });
                                    AppSnackBar.instance.show(provider.logoutResponse?.message ?? "Terjadi Kesalahan, Coba Beberapa Saat Lagi");
                                  }
                                },
                                child: child!
                            );
                          },
                          child: Text("Keluar", style: AppTextStyle.regular12White,),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
