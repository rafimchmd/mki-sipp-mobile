import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sipp_mobile/constant/app_constant.dart';
import 'package:sipp_mobile/provider/research/research_provider.dart';
import 'package:sipp_mobile/repository/research/research_repo.dart';
import 'package:sipp_mobile/util/app_navigation.dart';

import '../../constant/textstyles.dart';
import '../../injector.dart';
import '../../util/cache_manager.dart';

class ResearchLocationScreen extends StatelessWidget {
  const ResearchLocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          ResearchProvider provider = ResearchProvider(locator<ResearchRepo>());
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
            await provider.getResearchList();
            if (provider.researchListResponse?.code == 401) {
              await CacheManager.instance.deleteUserSession();
              AppNavigation.instance.neglect(path: AppConstant.loginRoute);
            }
          });
          return provider;
        },
      child: const ResearchLocationBody(),
    );
  }
}

class ResearchLocationBody extends StatelessWidget {
  const ResearchLocationBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text("Penghitungan", style: AppTextStyle.bold14),
      ),
      body: Stack(
        children: [
          Consumer<ResearchProvider>(
              builder: (context, provider, child) {
                return FlutterMap(
                    options: const MapOptions(
                        initialCenter: LatLng(-6.943097, 107.633545),
                        initialZoom: 3.0,
                        interactionOptions: InteractionOptions(
                            enableScrollWheel: true,
                            flags: InteractiveFlag.all
                        )
                    ),
                    children: provider.mapChildren
                );
              },
            ),
          Positioned(
            top: 32,
            left: 32,
            child: Container(
              padding: const EdgeInsets.all(16),
              height: 350,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38.withOpacity(.25),
                    blurRadius: 60,
                    spreadRadius: 10,
                  ),
                ]
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("Daftar Lokasi", style: AppTextStyle.bold14Black,),
                  ),
                  Expanded(
                    child: Consumer<ResearchProvider>(
                      builder: (context, provider, child) {
                        return ListView.separated(
                          itemCount: provider.isLoading ? 3 : provider.researchListResponse?.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            return Visibility(
                              visible: !provider.isLoading,
                              replacement: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Shimmer.fromColors(
                                  enabled: true,
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(height: 24, decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey
                                  ),),
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  AppNavigation.instance.push(path: "/research/detail/${provider.researchListResponse?.data?[index].masterImageId ?? 0}");
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "${provider.researchListResponse?.data?[index].location} (${provider.researchListResponse?.data?[index].province})",
                                    style: AppTextStyle.regular12Black,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Visibility(
                              visible: !provider.isLoading,
                              replacement: Divider(
                                color: Colors.grey.shade300,
                              ),
                              child: const Divider(),
                            ),
                          ),);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
