import 'package:code_architect/src/device_info/device_info.dart';
import 'package:flutter/material.dart';

// back-end branch

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DeviceDetails(),
    );
  }
}

class DeviceDetails extends StatefulWidget {
  const DeviceDetails({super.key});

  @override
  State<DeviceDetails> createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends State<DeviceDetails> {
  DeviceInfo deviceInfo = DeviceInfo();

  @override
  void initState() {
    super.initState();
    // deviceInfo.getCurrentLocation();
    deviceInfo.getCurrentLocation(() {
      setState(() {}); // rebuild UI when location updates
    });

    deviceInfo.getAppInfo(() {
      setState(() {}); // rebuild UI when location updates
    });

    deviceInfo.getDeviceId(() {
      setState(() {}); // rebuild UI when location updates
    });

    deviceInfo.getIpAddress(() {
      setState(() {});
    });

    // print(deviceInfo.latitude);
    // print(deviceInfo.longitude);
    // print(deviceInfo.appName);
    // print(deviceInfo.packageName);
    // print(deviceInfo.version);
    // print(deviceInfo.buildNumber);
    // print(deviceInfo.androidInfo);
    // print(deviceInfo.iosInfo);
    // print(deviceInfo.ipv4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Device Location"),
      ),
      body: Center(
        child: deviceInfo.latitude != null && deviceInfo.longitude != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Latitude: ${deviceInfo.latitude}"),
                  Text("Longitude: ${deviceInfo.longitude}"),
                  Text("appName: ${deviceInfo.appName}"),
                  Text("packageName: ${deviceInfo.packageName}"),
                  Text("version: ${deviceInfo.version}"),
                  Text("buildNumber: ${deviceInfo.buildNumber}"),
                  Text("Device Type: ${deviceInfo.devicetype}"),
                  Text("androidInfo: ${deviceInfo.deviceId}"),
                  Text("Ios Info: ${deviceInfo.iosInfo}"),
                  Text("IP-Address: ${deviceInfo.ipv4}"),
                ],
              )
            : Text(deviceInfo.locationStatus ?? "Fetching location..."),
      ),
    );
  }
}
