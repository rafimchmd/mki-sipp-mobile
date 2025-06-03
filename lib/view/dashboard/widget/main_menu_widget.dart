import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import '../../../constant/app_constant.dart';
import '../../../constant/colors.dart';
import '../../../constant/textstyles.dart';
import '../../../util/app_navigation.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // width: 400,
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Menu Utama", style: AppTextStyle.regular14Black,),
            const SizedBox(height: 16,),
            Material(
              type: MaterialType.transparency,
              child: ListTile(
                title: Text("Penghitungan Lapangan", style: AppTextStyle.bold14Black,),
                subtitle: Text('Laporan hasil penghitungan lapangan yang sudah di lakukan', style: AppTextStyle.regular12Black,),
                leading: Icon(Icons.search_off_rounded, color: AppColor.purple,),
                splashColor: Colors.grey[250],
                hoverColor: Colors.grey[100],
                onTap: () {
                  FirebaseAnalytics.instance.logEvent(name: "Research_Report_Clicked");
                  AppNavigation.instance.push(path: AppConstant.researchListRoute);
                },
              ),
            ),
            Material(
              type: MaterialType.transparency,
              child: ListTile(
                title: Text("Program Deteksi Objek", style: AppTextStyle.bold14Black,),
                subtitle: Text('Pendeteksian secara langsung untuk penghitungan', style: AppTextStyle.regular12Black,),
                leading: Icon(Icons.settings_overscan_sharp, color: AppColor.bgGreenColor,),
                splashColor: Colors.grey[250],
                hoverColor: Colors.grey[100],
                onTap: () {
                  FirebaseAnalytics.instance.logEvent(name: "Realtime_Detector_Clicked");
                  AppNavigation.instance.push(path: AppConstant.researchDetectRoute);
                },
              ),
            ),
            Material(
              type: MaterialType.transparency,
              child: ListTile(
                title: Text("Kompres Gambar", style: AppTextStyle.bold14Black,),
                subtitle: Text('Pendeteksian secara langsung untuk penghitungan', style: AppTextStyle.regular12Black,),
                leading: Icon(Icons.photo_size_select_actual_outlined, color: AppColor.deepBlue,),
                splashColor: Colors.grey[250],
                hoverColor: Colors.grey[100],
                onTap: () {
                  FirebaseAnalytics.instance.logEvent(name: "Image_Compressor_Clicked");
                  AppNavigation.instance.push(path: AppConstant.imageCompressor);
                },
              ),
            ),
          ],
        )
    );
  }
}
