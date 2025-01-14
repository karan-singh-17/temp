import 'dart:developer';
import 'dart:io';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:moe/data/services/AWS/IoTLamda/system_provider.dart';
import 'package:moe/data/services/AWS/IoTLamda/user_provider_class.dart';
import 'package:moe/data/services/AWS/aws_services.dart';
import 'package:moe/domain/providers/add_provider.dart';
import 'package:moe/domain/providers/forecast_provider.dart';
import 'package:moe/domain/viewmodels/navBarController.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:moe/amplifyconfiguration.dart';
import 'domain/helper/Database_Helper(local).dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<Directory> getStorageDirectory() async {
  final a = await getApplicationDocumentsDirectory();
  log('ApplicationDocumentsDirectory: $a');
  return a;
}

Future<void> bootstrap(ValueGetter<Widget> app) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");

  Hive.init((await getStorageDirectory()).path);

  await DatabaseHelper().database;

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getStorageDirectory(),
  );

  await Permission.bluetooth.request();
  await Permission.bluetoothScan.request();
  await Permission.location.request();
  await Permission.bluetoothConnect.request();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AddProvider()),
      ChangeNotifierProvider(create: (_) => ForecastProvider()),
      // ChangeNotifierProvider(create: (_) => AWSServices()),
      ChangeNotifierProvider(create: (_) => NavBarController()),
      ChangeNotifierProvider(create: (_) => DeviceProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider())
    ], child: app()),
  );
  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
}
