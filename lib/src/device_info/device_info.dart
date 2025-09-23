import 'dart:io';
import 'dart:ui';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb

class DeviceInfo {
  double? latitude, longitude;
  String? locationStatus;
  String? appName, packageName, version, buildNumber;
  var androidInfo, iosInfo;
  var ipv4;
  String? devicetype;
  String deviceId = "unknown";

  Future<void> getCurrentLocation(VoidCallback onUpdate) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      locationStatus = "Location services are disabled.";
      return;
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        locationStatus = "Location permissions are denied";
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      locationStatus =
          "Location permissions are permanently denied, cannot request.";
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latitude = position.latitude;
    longitude = position.longitude;
    locationStatus = "Location fetched successfully";
    onUpdate(); // Notify UI
  }

  Future<void> getAppInfo(VoidCallback onupdate) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
    print("App Name: ${packageInfo.appName}");
    print("Package Name: ${packageInfo.packageName}");
    print("Version: ${packageInfo.version}");
    print("Build Number: ${packageInfo.buildNumber}");
    onupdate(); // Notify UI
  }

  Future<String> getDeviceId(VoidCallback onUpdate) async {
    final deviceInfo = DeviceInfoPlugin();

    if (kIsWeb) {
      devicetype = "Web";
      deviceId = "web_device";
    } else if (Platform.isAndroid) {
      devicetype = "Android";
      androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id; // unique Android ID
    } else if (Platform.isIOS) {
      devicetype = "iOS";
      iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? "unknown";
    } else if (Platform.isWindows) {
      devicetype = "Windows";
      var winInfo = await deviceInfo.windowsInfo;
      deviceId = winInfo.deviceId ?? "unknown";
    } else if (Platform.isMacOS) {
      devicetype = "MacOS";
      var macInfo = await deviceInfo.macOsInfo;
      deviceId = macInfo.systemGUID ?? "unknown";
    } else {
      devicetype = "Other";
    }

    onUpdate(); // rebuild UI
    return deviceId;
  }

  getIpAddress(VoidCallback onUpdate) async {
    ipv4 = await Ipify.ipv4();
    print(ipv4);
    onUpdate();
  }
}
