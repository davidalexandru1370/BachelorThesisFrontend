import 'package:frontend/domain/constants/api_constants.dart';
import 'package:frontend/domain/constants/app_constants.dart';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../../domain/exceptions/unauthenticated_exception.dart';
import '../secure_storage/secure_storage.dart';

class WebSocketConnection {
  static final WebSocketConnection instance = WebSocketConnection._init();
  static final SecureStorage _storage = SecureStorage();
  static late HubConnection? hubConnection;
  WebSocketConnection._init();

  static void init() {
    hubConnection = HubConnectionBuilder()
        .withUrl(ApiConstants.WEBSOCKET_URL + "/hubs/createFolder/notification",
        options: HttpConnectionOptions(
            logMessageContent: true,
            accessTokenFactory: () async => await _storage.readOrThrow(
                AppConstants.ACCESS_TOKEN, UnauthenticatedException())))
        .build();

  }

  Future<void> listen(Function onReceive) async {
    hubConnection!.on("SendNewStatus", (arguments) {
      Logger().log(Level.info, "Received message: $arguments");
      onReceive(arguments);
    });
  }
}
