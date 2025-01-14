// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';
// import 'package:moe/screens/views/bluetoothconnectscreen/DeviceConnectedSuccessScreen.dart';
//
// import '../../../domain/helper/Colors.dart';
// import '../../../domain/helper/UtilHelper.dart';
//
// class QrScannerScreen extends StatefulWidget {
//   const QrScannerScreen({super.key});
//
//   @override
//   State<QrScannerScreen> createState() => _QrScannerScreenState();
// }
//
// class _QrScannerScreenState extends State<QrScannerScreen> {
//   ///Declaring variable
//   Barcode? result;
//   QRViewController? controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//
//   ///reassemble method to check device
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller?.pauseCamera();
//     } else if (Platform.isIOS) {
//       controller!.resumeCamera();
//     }
//   }
//
//   ///initState Method
//   @override
//   void initState() {
//     super.initState();
//     // TODO: implement initState
//     navigateToDeviceConnectedSuccessScreen();
//   }
//
//   ///dispose method
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
//
//   ///Temporary for showing screen design
//   navigateToDeviceConnectedSuccessScreen() {
//     ///Navigate to successfully connected screen after 4 seconds
//     Timer(const Duration(seconds: 4), () async {
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (builder) => const DeviceConnectedSuccessScreen()));
//     });
//   }
//
//   ///QR code overlay
//   Widget _buildQrView(BuildContext context) {
//     return QRView(
//       key: qrKey,
//       onQRViewCreated: _onQRViewCreated,
//       overlay: QrScannerOverlayShape(
//           borderColor: context.isDarkMode ? white : black,
//           borderRadius: 20,
//           borderLength: 30,
//           borderWidth: 10,
//           overlayColor: context.isDarkMode ? black : white),
//     );
//   }
//
//   ///On Qr code created
//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         result = scanData;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         color: context.isDarkMode ? black : primaryLightBackgroundColor,
//         width: double.infinity,
//         height: double.infinity,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(
//               height: MediaQuery.of(context).padding.top + 40,
//             ),
//             SvgPicture.asset(context.isDarkMode
//                 ? "assets/images/deviceaddscreenappiconfordarkmode.svg"
//                 : "assets/images/deviceaddscreenappiconforlightmode.svg"),
//             Expanded(child: _buildQrView(context)
//
//                 ///QR code overlay
//                 ),
//             Text("Scannen Sie den QR-Code",
//                 style: fontStyling(
//                   25.0,
//                   FontWeight.w700,
//                   context.isDarkMode ? white : black,
//                 )),
//             Text(
//               'Scannen Sie den QR-Code auf der Unterseite des Gateways, um die Installation fortzusetzen',
//               style: TextStyle(
//                   fontSize: 14.0,
//                   fontWeight: FontWeight.w500,
//                   color: grey,
//                   fontStyle: FontStyle.italic),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(
//               height: 60,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
