import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker checker;

  NetworkInfoImpl(this.checker);
  @override
  Future<bool> get isConnected => checker.hasConnection;
}
