import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sipp_mobile/component/other/snackbar.dart';
import 'package:sipp_mobile/constant/app_constant.dart';
import 'package:sipp_mobile/model/request/login_request.dart';
import 'package:sipp_mobile/provider/auth/auth_provider.dart';
import 'package:sipp_mobile/repository/auth/auth_repo.dart';
import 'package:sipp_mobile/util/app_navigation.dart';

import '../../component/button/base_button.dart';
import '../../component/input/base_input.dart';
import '../../constant/textstyles.dart';
import '../../enums/button_style.dart';
import '../../injector.dart';

class LoginBase extends StatelessWidget {
  const LoginBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AuthProvider(locator<AuthRepo>()),
      child: const Login(),
    );
  }
}


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    FirebaseAnalytics.instance.logEvent(name: "Login_Screen");
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _handleLogin() {
    if(context.read<AuthProvider>().loginResponse?.code != 200) {
      FirebaseAnalytics.instance.logEvent(name: "Login_Failed", parameters: {
        "error_code": context.read<AuthProvider>().loginResponse?.code
      });
      AppSnackBar.instance.show(context.read<AuthProvider>().loginResponse?.message);
    } else {
      FirebaseAnalytics.instance.logEvent(name: "Login_Success");
      AppNavigation.instance.neglect(path: AppConstant.dashboardRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    const SizedBox(height: 24,),
                    BaseInput(controller: _emailController, hint: "Email"),
                    const SizedBox(height: 16,),
                    BaseInput(controller: _passwordController, hint: "Password", obscureText: true,),
                    const SizedBox(height: 24,),
                    SizedBox(
                      child: BaseButton(
                        onPressed: () async {
                          await context.read<AuthProvider>().login(LoginRequest(
                              email: _emailController.text.toString(),
                              password: _passwordController.text.toString()
                          ));
                          _handleLogin();
                        },
                        buttonStyle: AppButtonStyle.greenFilled,
                        child: Text("Masuk", style: AppTextStyle.bold12White,),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Belum punya akun?", style: AppTextStyle.regular14Black,),
                        const SizedBox(width: 3,),
                        InkWell(
                            onTap: () {
                              FirebaseAnalytics.instance.logEvent(name: "Register_Clicked");
                              AppNavigation.instance.push(path: AppConstant.registerRoute);
                            },
                            child: Text("Daftar", style: AppTextStyle.bold14Green,)
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
