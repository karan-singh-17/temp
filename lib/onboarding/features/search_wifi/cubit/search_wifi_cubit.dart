import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nineti_heimspeicher/nineti_heimspeicher.dart';

part 'search_wifi_state.dart';

class SearchWifiCubit extends Cubit<SearchWifiState> {
  final HeimspeicherSystem heimspeicher;

  SearchWifiCubit({
    required this.heimspeicher,
  }) : super(const SearchWifiState());

  Future<void> scanForWifi() async {
    final scanResults = await heimspeicher.scanForWifi();
    emit(state.copyWith(foundWiFis: scanResults));
  }
}
