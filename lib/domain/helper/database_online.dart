import 'dart:convert';
import 'package:http/http.dart' as http;

class S3PanelService {

  Future<bool> uploadPanels(String fileName, List<Map<String, dynamic>> panels) async {
    try {
      final response = await http.post(
        Uri.parse('https://t4fxoudlxf7miyili246rgpo7e0gfxge.lambda-url.eu-central-1.on.aws/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'file_name': fileName,
          'operation': 'add',
          'panels': panels,
        }),
      );

      if (response.statusCode == 200) {
        print('Upload successful: ${response.body}');
        return true;
      } else {
        print('Failed to upload: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error uploading panels: $e');
      return false;
    }
  }

  // Function to delete a panel from a file in S3
  Future<bool> deletePanel(String fileName, String batteryNo, String panelNo) async {
    try {
      final response = await http.post(
        Uri.parse('https://t4fxoudlxf7miyili246rgpo7e0gfxge.lambda-url.eu-central-1.on.aws/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'file_name': fileName,
          'operation': 'delete',
          'battery_no': batteryNo, // Include battery_no
          'panel_no': panelNo,     // Include panel_no
        }),
      );

      if (response.statusCode == 200) {
        print('Delete successful: ${response.body}');
        return true;
      } else {
        print('Failed to delete: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting panel: $e');
      return false;
    }
  }


  // Function to download the JSON file from S3
  Future<Map<String, dynamic>?> downloadFile(String fileName) async {
    try {
      final response = await http.get(
        Uri.parse('https://ywwutdbumbgadpc7fs4wuqzqe40ktnxv.lambda-url.eu-central-1.on.aws/?file_name=$fileName'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Download successful: ${response.body}');
        return data;
      } else {
        // Check if error message indicates the file does not exist
        if (response.body.contains("NoSuchKey")) {
          print('File not found: Returning empty map');
          return {}; // Return empty map if file doesn't exist
        }
        print('Failed to download: ${response.body}');
        return {};
      }
    } catch (e) {
      print('Error downloading file: $e');
      return {}; // Return empty map if an exception occurs
    }
  }


  // Function to get a specific panel based on battery_no and panel_no
  Future<Map<String, dynamic>?> getPanelByBatteryAndPanelNo(
      String fileName, String batteryNo, String panelNo) async {
    try {
      final response = await http.get(
        Uri.parse('https://ywwutdbumbgadpc7fs4wuqzqe40ktnxv.lambda-url.eu-central-1.on.aws/?file_name=$fileName'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final panel = data['panels'].firstWhere(
                (panel) =>
            panel['battery_no'] == batteryNo && panel['panel_no'] == panelNo,
            orElse: () => null);

        if (panel != null) {
          print('Panel found: $panel');
          return panel;
        } else {
          print('Panel not found');
          return null;
        }
      } else {
        print('Failed to download: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error retrieving panel: $e');
      return null;
    }
  }
}
