import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

// Enum trạng thái mạng
enum NetworkStatus {
  offline,
  weakConnection,
  online,
}

class NetworkChecker {
  static final NetworkChecker _instance = NetworkChecker._internal();
  final Connectivity _connectivity = Connectivity();
  final StreamController<NetworkStatus> _statusController = StreamController<NetworkStatus>.broadcast();

  factory NetworkChecker() => _instance;

  NetworkChecker._internal() {
    _init();
  }

  Stream<NetworkStatus> get statusStream => _statusController.stream;

  Future<void> _init() async {
    try {
      // Kiểm tra trạng thái ban đầu
      var result = await _connectivity.checkConnectivity();
      if (result.isNotEmpty) {
        _updateStatus(result.first);
      }

      // Lắng nghe thay đổi kết nối
      _connectivity.onConnectivityChanged.listen((results) {
        if (results.isNotEmpty) {
          _updateStatus(results.first);
        }
      });
    } on PlatformException catch (e) {
      debugPrint('Error checking connectivity: $e');
      _statusController.add(NetworkStatus.offline);
    }
  }

  void _updateStatus(ConnectivityResult result) async {
    NetworkStatus status;

    if (result == ConnectivityResult.none) {
      status = NetworkStatus.offline;
    } else {
      // Kiểm tra chất lượng kết nối
      bool isWeak = await _checkConnectionQuality();
      status = isWeak ? NetworkStatus.weakConnection : NetworkStatus.online;
    }

    _statusController.add(status);
  }

  Future<bool> _checkConnectionQuality() async {
    // Giả định kết nối mobile là yếu (2G/3G)
    var result = await _connectivity.checkConnectivity();
    // ignore: unrelated_type_equality_checks
    return result == ConnectivityResult.mobile;
  }

  void dispose() {
    _statusController.close();
  }
}

// Widget hiển thị thông báo mạng
class NetworkStatusBanner extends StatelessWidget {
  const NetworkStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NetworkStatus>(
      stream: NetworkChecker().statusStream,
      builder: (context, snapshot) {
        final status = snapshot.data ?? NetworkStatus.online;
        final isVisible = status != NetworkStatus.online;

        return AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          bottom: isVisible ? 0 : -40,
          left: 0,
          right: 0,
          child: Material(
            color: status == NetworkStatus.offline ? Colors.red : Colors.orange,
            child: SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    status == NetworkStatus.offline
                        ? Icons.wifi_off
                        : Icons.signal_wifi_statusbar_connected_no_internet_4,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    status == NetworkStatus.offline ? 'No internet connection' : 'Weak network connection',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Cách sử dụng trong API call (ví dụ với Dio)
Future<Response> safeApiCall(Future<Response> Function() apiCall) async {
  final networkStatus = await NetworkChecker().statusStream.first;

  if (networkStatus == NetworkStatus.offline) {
    throw Exception('No internet connection');
  }

  // Set timeout dựa trên chất lượng mạng
  final timeout =
      networkStatus == NetworkStatus.weakConnection ? const Duration(seconds: 20) : const Duration(seconds: 10);

  return apiCall().timeout(timeout, onTimeout: () {
    throw Exception('Request timed out');
  });
}
