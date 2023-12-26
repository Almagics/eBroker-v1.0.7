// ignore_for_file: non_constant_identifier_names, file_names

class AppPic {
  AppPic._();
  //
  static const String _basePath = "assets/";
  //** */
  static String splashLogopng = _pngPath("ic_launcher_round");

  ///
  static String _pngPath(String name) {
    return "$_basePath$name.png";
  }
}
