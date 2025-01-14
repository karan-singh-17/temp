import 'dart:io';

import 'package:ble_connector/ble_connector.dart';
import 'package:moe/data/services/AWS/IoTLamda/get_put_user_table.dart';
import 'package:moe/onboarding/features/cloud_provisioning/domain/fetch_provisioning_package.dart';
import 'package:moe/onboarding/util/value_stream_builder.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nineti_heimspeicher/nineti_heimspeicher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CloudProvisioningPage extends StatefulWidget {
  final BLEDevice device;
  const CloudProvisioningPage({super.key, required this.device});

  @override
  State<CloudProvisioningPage> createState() => _CloudProvisioningPageState();
}

class _CloudProvisioningPageState extends State<CloudProvisioningPage> {
  File? provisioningPackage;
  ProvisioningPackager packager = ProvisioningPackager();
  final cwd = Directory.current.path;
  String isDownloading = 'Not downloaded';
  GetPutUserTable userTableObject = GetPutUserTable();

  void fetchProvision(ProvisioningPackager packager) async {
    setState(() {
      isDownloading = 'Downloading...';
    });
    try {
      await packager
          .fetchProvisioningPackage(widget.device.id.replaceAll(":", "_"));
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final filePath = sharedPreferences.getString('provisioningPath');
      provisioningPackage = File(filePath!);
      setState(() {
        isDownloading = 'Successfully downloaded. Please tap provision.';
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onProvision() async {
      if (provisioningPackage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No provisioning file exists in storage.'),
          ),
        );
        return;
      }

      final heimspeicher = context.read<HeimspeicherSystem>();
      final provisioningData = provisioningPackage!.readAsBytesSync();
      heimspeicher.provisionCloudConnection(provisioningData);
      final String systemID = widget.device.id.replaceAll(":", "_");
      final GetPutUserTable userApi = GetPutUserTable();
      // final SharedPreferences prefs = await SharedPreferences.getInstance();
      // final String email =  prefs.getString('email')!;
      await userApi.putUserTableData(systemID);
    }

    return ValueStreamBuilder(
        stream: context.read<HeimspeicherSystem>().cloudProvisioningStatus,
        builder: (context, status) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Cloud Provisioning'),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: onProvision,
              label: const Text('Provision'),
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Card(
                  child: ListTile(
                    title: const Text('Provisioning Status'),
                    subtitle: Text(status.data?.toString() ?? 'NO DATA'),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Provisioning Package'),
                    subtitle: Text(
                      provisioningPackage?.path ?? 'No file selected',
                      softWrap: true,
                    ),
                  ),
                ),
                Card(
                  child: GestureDetector(
                    onTap: () => fetchProvision(packager),
                    child: ListTile(
                      title: const Text('Download Provisioning package'),
                      subtitle: Text(isDownloading),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
