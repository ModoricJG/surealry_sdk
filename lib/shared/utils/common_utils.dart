
import 'dart:io';

import 'package:surearly_smart_sdk/shared/enums/enums.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CommonUtils {
  String currentOsType() {
    return (Platform.isAndroid) ? OsType.AOS.name : OsType.IOS.name;
  }

  static Future<String> appVersion() async {
    final fromPlatform = await PackageInfo.fromPlatform();
    return fromPlatform.version;
  }
}