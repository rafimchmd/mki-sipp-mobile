


class AppConstant {
  static const String baseUrl = "https://treecounting.bnn.go.id/api";

  static Map<String, String> baseHeader = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  static String mainRoute = "/";
  static String loginRoute = "/login";
  static String registerRoute = "/register";
  static String dashboardRoute = "/dashboard";
  static String researchListRoute = "/research/list";
  static String researchLocationRoute = "/research/location";
  static String researchDetectRoute = "/research/detect";
  static String researchDetailRoute = "/research/detail/:id";
  static String imageCompressor = "/image-compressor";
}