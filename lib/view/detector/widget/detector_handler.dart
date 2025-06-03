import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sipp_mobile/constant/colors.dart';
import 'package:sipp_mobile/provider/detector/detector_provider.dart';
import 'package:sipp_mobile/provider/detector/osm_provider.dart';
import 'package:sipp_mobile/repository/detector/detector_repo.dart';
import 'package:sipp_mobile/repository/osm/osm_repo.dart';
import 'package:sipp_mobile/util/app_navigation.dart';
import 'package:sipp_mobile/view/detector/widget/region_field_widget.dart';

import '../../../component/button/base_button.dart';
import '../../../component/input/base_input.dart';
import '../../../constant/textstyles.dart';
import '../../../enums/button_style.dart';
import '../../../injector.dart';
import '../../../model/osm_model.dart';

class DetectorHandler {
  
  static Future<int?> showRegionField() async {
    int? region = await showModalBottomSheet<int?>(
      isDismissible: false,
      context: AppNavigation.instance.getContext()!,
      builder: (bottomSheetContext) {
        return ChangeNotifierProvider(
          create: (context) => DetectorProvider(locator<DetectorRepo>()),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Pengaturan Tambahan", style: AppTextStyle.bold18Black,),
                const SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Banyak region pada gambar:", style: AppTextStyle.regular12Black,),
                    const RegionField()
                  ],
                ),
                const SizedBox(height: 24,),
                SizedBox(
                  width: double.infinity,
                  child: Consumer<DetectorProvider>(
                    builder: (context, value, child) => BaseButton(
                        buttonStyle: AppButtonStyle.greenFilled,
                        onPressed: () {
                          AppNavigation.instance.pop(context.read<DetectorProvider>().maxRegion);
                        },
                        child: Text("Simpan", style: AppTextStyle.regular14White,)
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
    return region;
  }
  
  static Future<bool> showCancelConfirmation() async {
    bool cancel = await showModalBottomSheet(
        context: AppNavigation.instance.getContext()!,
        builder: (context) {
          return Padding(
              padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Ulang Proses dari Awal?", style: AppTextStyle.bold18Black, textAlign: TextAlign.center,),
                const SizedBox(height: 16,),
                Text("Semua informasi yang sudah kamu input akan hilang dan tidak tersimpan, apakah kamu yakin?", style: AppTextStyle.regular12Black, textAlign: TextAlign.center,),
                const SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: BaseButton(
                        onPressed: () {
                          AppNavigation.instance.pop(false);
                        },
                        buttonStyle: AppButtonStyle.redFilled,
                        child: Text("Tidak Jadi", style: AppTextStyle.regular14White,),
                      ),
                    ),
                    const SizedBox(width: 24,),
                    Expanded(
                      child: BaseButton(
                        onPressed: () {
                          AppNavigation.instance.pop(true);
                        },
                        buttonStyle: AppButtonStyle.greenFilled,
                        child: Text("Ya, Saya Yakin", style: AppTextStyle.regular14White,),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
    );
    return cancel;
  }

  static Future<OpenStreetMapModel?> showLocationSelection() async {
    final TextEditingController searchController = TextEditingController();
    OpenStreetMapModel? selected = await showModalBottomSheet<OpenStreetMapModel?>(
        context: AppNavigation.instance.getContext()!,
        builder: (context) {
          return ChangeNotifierProvider(
            create: (context) => OSMProvider(locator<OSMRepo>()),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pilih Lokasi Penghitungan", style: AppTextStyle.bold18Black,),
                  const SizedBox(height: 16,),
                  Row(
                    children: [
                      Expanded(
                        child: BaseInput(
                          controller: searchController,
                          hint: "Cari Lokasi",
                        ),
                      ),
                      const SizedBox(width: 16,),
                      Consumer<OSMProvider>(
                        builder: (context, value, child) => TextButton(onPressed: () async {
                          await context.read<OSMProvider>().searchLocation(location: searchController.text);
                        }, child: Text("Cari", style: AppTextStyle.regular14Primary,)),
                      )
                    ],
                  ),
                  const SizedBox(height: 24,),
                  Consumer<OSMProvider>(
                    builder: (context, provider, child) => Visibility(
                      visible: !provider.isLoading,
                      replacement: Expanded(
                        child: Center(
                          child: CircularProgressIndicator(color: AppColor.primaryColor,),
                        ),
                      ),
                      child: Visibility(
                        visible: provider.location != null,
                        replacement: Expanded(
                          child: Center(child: Text("Lokasi tidak di temukan", style: AppTextStyle.regular14Black,)),
                        ),
                        child: Expanded(
                          child: ListView.builder(
                            shrinkWrap: false,
                            physics: const ScrollPhysics(),
                            itemCount: provider.location?.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  '${provider.location?[index].displayname}',
                                  style: AppTextStyle.regular14Black,
                                ),
                                subtitle: Text(
                                  '${provider.location?[index].lat}, ${provider.location?[index].lon}',
                                  style: AppTextStyle.regular12Black,
                                ),
                                onTap: () {
                                  searchController.text = "${provider.location?[index].displayname}";
                                  provider.setSelectedLocation(provider.location?[index]);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24,),
                  SizedBox(
                    width: double.infinity,
                    child: Consumer<OSMProvider>(
                      builder: (context, provider, child) => BaseButton(
                          buttonStyle: AppButtonStyle.greenFilled,
                          onPressed: provider.selectedLocation != null ? () {
                            AppNavigation.instance.pop(provider.selectedLocation);
                          } : null,
                          child: Text("Simpan", style: AppTextStyle.regular14White,)
                      ),
                    )
                  )
                ],
              ),
            ),
          );
        },
    );
    return selected;
  }
}