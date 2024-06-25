import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class EventChannelMock {
  final Stream stream;
  final MethodChannel _methodChannel;
  final log = <MethodCall>[];

  StreamSubscription? _subscription;

  EventChannelMock({
    required String channelName,
    required this.stream,
  }) : _methodChannel = MethodChannel(channelName) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_methodChannel, _handler);
  }

  Future<dynamic> _handler(MethodCall methodCall) async {
    log.add(methodCall);

    switch (methodCall.method) {
      case 'listen':
        _onListen();
        break;
      case 'cancel':
        _onCancel();
        break;
      default:
        return Future.value(null);
    }

    return Future.value();
  }

  void _onListen() {
    _subscription = stream.handleError((e) {
      _sendErrorEnvelope(e);
    }).listen(
      _sendSuccessEnvelope,
      onDone: () {
        _sendEnvelope(null);
      },
    );
  }

  void _onCancel() {
    _subscription?.cancel();
  }

  void _sendErrorEnvelope(Exception error) {
    var code = 'UNKNOWN_EXCEPTION';
    String? message;
    dynamic details;

    if (error is PlatformException) {
      code = error.code;
      message = error.message;
      details = error.details;
    }

    final envelope = const StandardMethodCodec().encodeErrorEnvelope(
      code: code,
      message: message,
      details: details,
    );

    _sendEnvelope(envelope);
  }

  void _sendSuccessEnvelope(dynamic event) {
    final envelope = const StandardMethodCodec().encodeSuccessEnvelope(event);
    _sendEnvelope(envelope);
  }

  void _sendEnvelope(ByteData? envelope) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(
      _methodChannel.name,
      envelope,
      (_) {},
    );
  }
}
