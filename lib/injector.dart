import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:sipp_mobile/data/network.dart';
import 'package:sipp_mobile/provider/auth/auth_provider.dart';
import 'package:sipp_mobile/provider/detector/detector_provider.dart';
import 'package:sipp_mobile/provider/detector/osm_provider.dart';
import 'package:sipp_mobile/provider/research/research_detail_provider.dart';
import 'package:sipp_mobile/provider/research/research_provider.dart';
import 'package:sipp_mobile/repository/auth/auth_repo.dart';
import 'package:sipp_mobile/repository/auth/auth_repo_imp.dart';
import 'package:sipp_mobile/repository/detector/detector_repo.dart';
import 'package:sipp_mobile/repository/detector/detector_repo_imp.dart';
import 'package:sipp_mobile/repository/osm/osm_repo.dart';
import 'package:sipp_mobile/repository/osm/osm_repo_imp.dart';
import 'package:sipp_mobile/repository/research/research_repo.dart';
import 'package:sipp_mobile/repository/research/research_repo_imp.dart';
import 'package:sipp_mobile/util/app_navigation.dart';

GetIt locator = GetIt.instance;

Future<void> registerDependency() async {
  if(!locator.isRegistered(instance: http.Client())) {
    locator.registerSingleton<http.Client>(http.Client());
  }
  if(!locator.isRegistered(instance: Network(locator<http.Client>()))) {
    locator.registerSingleton<Network>(Network(locator<http.Client>()));
  }

  locator.registerFactory<AuthRepo>(() => AuthRepoImp(locator<Network>()));
  locator.registerFactory<ResearchRepo>(() => ResearchRepoImp(locator<Network>()));
  locator.registerFactory<OSMRepo>(() => OSMRepoImp());
  locator.registerFactory<DetectorRepo>(() => DetectorRepoImp(locator<Network>()));

  locator.registerFactory<AuthProvider>(() => AuthProvider(locator<AuthRepo>()));
  locator.registerFactory<ResearchProvider>(() => ResearchProvider(locator<ResearchRepo>()));
  locator.registerFactory<ResearchDetailProvider>(() => ResearchDetailProvider(locator<ResearchRepo>()));
  locator.registerFactory<OSMProvider>(() => OSMProvider(locator<OSMRepo>()));
  locator.registerFactory<DetectorProvider>(() => DetectorProvider(locator<DetectorRepo>()));

  locator.registerFactory<AppNavigation>(() => AppNavigation());

}