part of 'search_wifi_cubit.dart';

class SearchWifiState extends Equatable {
  const SearchWifiState({
    this.foundWiFis = const [],
  });

  final List<WiFiScanEntry> foundWiFis;

  SearchWifiState copyWith({
    List<WiFiScanEntry>? foundWiFis,
    WiFiStatus? status,
  }) {
    return SearchWifiState(
      foundWiFis: foundWiFis ?? this.foundWiFis,
    );
  }

  @override
  List<Object> get props => [foundWiFis];
}
