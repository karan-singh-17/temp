import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProvisioningPackager {
  Future<void> fetchProvisioningPackage(String deviceID) async {
    try {
      final headers = {
        "Authorization": "ujhN1Tl76w8M",
      };
      final url = Uri.parse("https://5usiyx3rju3unbh724teedh4zm0pcggd.lambda-url.eu-central-1.on.aws/?deviceid=$deviceID");

      final response = await http.get(url, headers: headers);

      if (response.statusCode != 200) {
        throw HttpException(
            'Failed to fetch provisioning package. Status code: ${response.statusCode}. Message: ${response.body}');
      }

      final responseDict = json.decode(utf8.decode(response.bodyBytes));

      final tempDir = await getTemporaryDirectory();
      final certificateFile = File('${tempDir.path}/certificate.pem');
      await certificateFile.writeAsString(responseDict["certificatePem"]);

      final privateKeyFile = File('${tempDir.path}/provisioning_key');
      await privateKeyFile.writeAsString(responseDict["keyPair"]["PrivateKey"]);

      final publicKeyFile = File('${tempDir.path}/provisioning_key.pub');
      await publicKeyFile.writeAsString(responseDict["keyPair"]["PublicKey"]);

      final metadataFile = File('${tempDir.path}/metadata.json');
      await metadataFile.writeAsString(json.encode({
        "expiration": responseDict["expiration"],
        "deviceId": responseDict["deviceId"],
      }));

      final zipFile = File('${tempDir.path}/provisioning_package.zip');
      final encoder = ZipFileEncoder();
      encoder.create(zipFile.path);
      await encoder.addFile(certificateFile);
      await encoder.addFile(privateKeyFile);
      await encoder.addFile(publicKeyFile);
      await encoder.addFile(metadataFile);
      await encoder.close();

      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      await sharedPreferences.setString('provisioningPath', zipFile.path);
    } catch (e) {
      print('An error occurred: $e');
      rethrow;
    }
  }
}