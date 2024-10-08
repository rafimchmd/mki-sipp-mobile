import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sipp_mobile/constant/textstyles.dart';
import 'package:sipp_mobile/provider/base_provider.dart';

import '../../component/other/snackbar.dart';
import '../../model/research_list_response.dart';
import '../../repository/research/research_repo.dart';

class ResearchProvider extends BaseProvider {

  ResearchRepo repo;
  ResearchProvider(this.repo);

  ResearchListResponse? _researchListResponse;
  ResearchListResponse? get researchListResponse => _researchListResponse;

  final List<Widget> _mapChildren = [TileLayer(
    retinaMode: true,
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  )];

  List<Widget> get mapChildren => _mapChildren;

  Future<void> getResearchList() async {
    try {
      loading(true);
      _researchListResponse = await repo.getResearchList();
      await _onSuccessGetList();
    } catch (e) {
      loading(false);
      AppSnackBar.instance.show("Terjadi Kesalahan, Coba Beberapa Saat Lagi");
    }
  }

  _onSuccessGetList() {
    if(_researchListResponse?.code == 200) {
      if(_researchListResponse?.data?.isNotEmpty ?? true) {
        for(int i = 0; i < _researchListResponse!.data!.length; i++) {
          _mapChildren.add(
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(_researchListResponse?.data?[i].latitude ?? 0.0, _researchListResponse?.data?[i].longitude ?? 0.0),
                    width: 40,
                    height: 40,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(child: Text(_researchListResponse?.data?[i].location ?? "", style: AppTextStyle.regular6Black,)),
                        Image.asset("assets/images/general/map-marker-icon.png", width: 24, height: 24,),
                      ],
                    ),
                  ),
                ],
              )
          );
        }
      }
    }
    loading(false);
  }

}