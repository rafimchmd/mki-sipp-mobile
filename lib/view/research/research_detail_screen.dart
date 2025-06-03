import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sipp_mobile/component/other/shimmer.dart';
import 'package:sipp_mobile/constant/app_constant.dart';
import 'package:sipp_mobile/constant/colors.dart';
import 'package:sipp_mobile/provider/research/research_detail_provider.dart';
import 'package:sipp_mobile/repository/research/research_repo.dart';
import 'package:sipp_mobile/view/research/research_handler.dart';

import '../../constant/textstyles.dart';
import '../../injector.dart';
import '../../util/app_navigation.dart';
import '../../util/cache_manager.dart';

class ResearchDetail extends StatelessWidget {

  final int researchId;

  const ResearchDetail({Key? key, required this.researchId}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) {
        ResearchDetailProvider provider = ResearchDetailProvider(locator<ResearchRepo>());
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          await provider.getDetail(researchId);
          if (provider.detailResponse?.code == 401) {
            await CacheManager.instance.deleteUserSession();
            AppNavigation.instance.neglect(path: AppConstant.loginRoute);
          }
        });
        return provider;
      },
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Text("Detail Penghitungan", style: AppTextStyle.bold14),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<ResearchDetailProvider>(
                  builder: (context, provider, child) => Visibility(
                    visible: !provider.isLoading,
                    replacement: const AppShimmer(height: 280, width: double.infinity),
                    child: InteractiveViewer(
                      panEnabled: true,
                      minScale: 0.5,
                      maxScale: 6,
                      child: CachedNetworkImage(
                        height: 500,
                        width: double.infinity,
                        fit: BoxFit.fitHeight,
                        imageUrl: provider.detailResponse?.baseResourcePath ?? "",
                        placeholder: (context, url) {
                          return const AppShimmer(height: 280, width: double.infinity);
                        },
                        errorWidget: (context, url, error) {
                          return Container(height: 280, width: double.infinity, decoration: BoxDecoration(
                              color: Colors.grey.shade300
                          ),
                          child: Center(child: Text("Can't load image", style: AppTextStyle.regular12Black26,),),);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24,),
                Text("Hasil Penghitungan", style: AppTextStyle.bold14Black,),
                const SizedBox(height: 16,),
                Text("(Klik pada gambar untuk zoom in/out)", style: AppTextStyle.regular12Grey,),
                const SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Lokasi Penghitungan", style: AppTextStyle.regular12Grey,),
                        Consumer<ResearchDetailProvider>(
                          builder: (context, provider, child) => Visibility(
                            visible: !provider.isLoading,
                              replacement: const AppShimmer(height: 20, width: 100),
                              child: Text("${provider.detailResponse?.location} (${provider.detailResponse?.province})", 
                                style: AppTextStyle.regular14Black,)
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total Objek", style: AppTextStyle.regular12Grey,),
                            Consumer<ResearchDetailProvider>(
                                builder: (context, provider, child) {
                                  return Visibility(
                                    visible: !provider.isLoading,
                                      replacement: const AppShimmer(height: 20, width: 100),
                                      child: Text(provider.detailResponse?.totalObject.toString() ?? "-", style: AppTextStyle.regular14Black,)
                                  );
                                },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total Luasan", style: AppTextStyle.regular12Grey,),
                            Consumer<ResearchDetailProvider>(
                              builder: (context, provider, child) {
                                return Visibility(
                                    visible: !provider.isLoading,
                                    replacement: const AppShimmer(height: 20, width: 100),
                                    child: Text("${provider.detailResponse?.totalDimension.toString()} m²", style: AppTextStyle.regular14Black,)
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24,),
                Text("Lampiran Penghitungan", style: AppTextStyle.bold14Black,),
                const SizedBox(height: 8,),
                Text("(Klik pada gambar untuk perbesar)", style: AppTextStyle.regular12Grey,),
                const SizedBox(height: 20,),
                SizedBox(
                  height: 256,
                  child: Consumer<ResearchDetailProvider>(
                    builder: (context, provider, child) {
                      return ListView.builder(
                        itemCount: provider.isLoading ? 3 : provider.detailResponse?.regions?.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Visibility(
                            visible: !provider.isLoading,
                            replacement: const Row(
                              children: [
                                AppShimmer(height: 100, width: 100),
                                SizedBox(width: 10,)
                              ],
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 10,),
                                GestureDetector(
                                  onTap: () {
                                    ResearchHandler.instance.showImageDetail(
                                        provider.detailResponse?.regions?[index].regionResourcePath,
                                        provider.detailResponse?.regions?[index].countObject,
                                        provider.detailResponse?.regions?[index].dimension
                                    );
                                  },
                                  child: SizedBox(
                                    height: 256,
                                    width: 256,
                                    child: CachedNetworkImage(
                                        imageUrl: provider.detailResponse?.regions?[index].regionResourcePath ?? "-",
                                      fit: BoxFit.fitHeight,
                                      placeholder: (context, url) => const AppShimmer(height: 150, width: 150),
                                      errorWidget: (context, url, error) {
                                        return Container(height: 256, width: 256, decoration: BoxDecoration(
                                            color: Colors.grey.shade300
                                        ),
                                          child: Center(child: Text("Can't load image", style: AppTextStyle.regular12Black26,),),);
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24,),
                Visibility(visible: false, child: Text("Review", style: AppTextStyle.bold14Black,)),
                const Visibility(visible: false, child: SizedBox(height: 8,)),
                Visibility(
                  visible: false,
                  child: SizedBox(
                    height: 100,
                    child: ListView.builder(
                      itemCount: 0,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 235,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: AppColor.lightGrey,
                              width: 1
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset("assets/images/general/user-icon.png"),
                                  const SizedBox(width: 4,),
                                  Expanded(child: Text("Reviewer", style: AppTextStyle.bold12Black, maxLines: 2, overflow: TextOverflow.ellipsis,))
                                ],
                              ),
                              Expanded(child: Text("Review Text Should be here", style: AppTextStyle.regular12Black, maxLines: 2, overflow: TextOverflow.ellipsis,))
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
