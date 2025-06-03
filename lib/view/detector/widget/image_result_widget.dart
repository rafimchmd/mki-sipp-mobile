import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sipp_mobile/model/osm_model.dart';
import 'package:sipp_mobile/view/detector/widget/detector_handler.dart';
import 'package:sipp_mobile/view/research/research_handler.dart';

import '../../../component/other/shimmer.dart';
import '../../../constant/colors.dart';
import '../../../constant/textstyles.dart';
import '../../../provider/detector/detector_provider.dart';

class ImageResultWidget extends StatelessWidget {

  final TextEditingController provinceController;
  final TextEditingController locationController;

  const ImageResultWidget({Key? key, required this.provinceController, required this.locationController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DetectorProvider>(
      builder: (context, provider, child) => Visibility(
          visible: provider.isLoading == true,
          replacement: Visibility(
            visible: (provider.detectionResultResponse?.regions?.isNotEmpty ?? false) && !provider.isLoading,
            child: Column(
              children: [
                const SizedBox(height: 24,),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                        color: Colors.black.withOpacity(0.3),
                        width: 2,
                        style: BorderStyle.solid
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hasil Deteksi", style: AppTextStyle.bold14Black,),
                      const SizedBox(height: 16,),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: provider.detectionResultResponse?.regions?.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Stack(
                              clipBehavior: Clip.none,
                              fit: StackFit.loose,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(width: 14,),
                                    InkWell(
                                      onTap: provider.detectionResultResponse?.regions?[index].regionResourcePath != null ? () {
                                        ResearchHandler.instance.showImageDetail(
                                            provider.detectionResultResponse?.regions?[index].regionResourcePath,
                                            provider.detectionResultResponse?.regions?[index].countObject,
                                            provider.detectionResultResponse?.regions?[index].dimensionMeter);
                                      } : null,
                                      child: CachedNetworkImage(
                                        imageUrl: provider.detectionResultResponse?.regions?[index].regionResourcePath ?? "-",
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => const AppShimmer(height: 150, width: 150),
                                        errorWidget: (context, url, error) {
                                          return Container(height: 280, width: double.infinity, decoration: BoxDecoration(
                                              color: Colors.grey.shade300
                                          ),
                                            child: Center(child: Text("Can't load image", style: AppTextStyle.regular12Black26,),),);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                Positioned(
                                  top: -10,
                                  right: -10,
                                  child: InkWell(
                                    onTap: () async {
                                      String path = "${provider.detectionResultResponse?.baseResourceFolder}/${provider.detectionResultResponse?.regions?[index].filename}";
                                      await provider.delete(path,true, index: index);
                                    },
                                    child: const Icon(Icons.remove_circle_rounded, size: 32, color: Colors.red,),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24,),
                      Text("Informasi Penghitungan", style: AppTextStyle.bold14Black,),
                      const SizedBox(height: 16,),
                      ListTile(
                        title: Text(provider.selectedLocation == null ? 'Pilih Lokasi Penghitungan (Wajib)' :
                        "${provider.selectedLocation?.displayname}\nLatitude: ${provider.selectedLocation?.lat}\nLongitude: ${provider.selectedLocation?.lon}", style: AppTextStyle.regular12Black,),
                        trailing: Icon(Icons.check_circle_rounded, color: provider.selectedLocation == null ? Colors.grey : Colors.green, size: 24,),
                        onTap: () async {
                          OpenStreetMapModel? selected = await DetectorHandler.showLocationSelection();
                          provider.setLocation(selected);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 24,),
                CircularProgressIndicator(color: AppColor.primaryColor,),
              ],
            ),
          )),
    );
  }
}
