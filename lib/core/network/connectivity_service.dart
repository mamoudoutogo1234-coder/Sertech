import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityService {
  Future<bool> isOnline();
  Stream<bool> onConnectivityChanged();
}

class ConnectivityServiceImpl implements ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityServiceImpl(this._connectivity);

  @override
  Future<bool> isOnline() async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet) ||
        results.contains(ConnectivityResult.vpn);
  }

  @override
  Stream<bool> onConnectivityChanged() {
    return _connectivity.onConnectivityChanged.map(
      (results) =>
          results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.ethernet) ||
          results.contains(ConnectivityResult.vpn),
    );
  }
}
