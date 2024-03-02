import 'package:frontend/domain/constants/api_constants.dart';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketConnection {
  static final WebSocketConnection instance = WebSocketConnection._init();
  static WebSocketChannel? _channel = init();

  WebSocketConnection._init();

  static WebSocketChannel init() {
    try {
      var connection = WebSocketChannel.connect(
          Uri.parse(ApiConstants.BASE_URL + "/hubs/createFolder/notification"));
      return connection;
    } catch (e) {
      Logger().log(Level.error, "Error connecting to websocket: $e");
      return init();
    }
  }

  void listen(Function onReceive) {
    _channel!.stream.listen((event) {
      onReceive(event);
    });
  }
}
