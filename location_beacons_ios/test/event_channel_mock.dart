import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class EventChannelMock {
  final MethodChannel _methodChannel;
  final Stream stream;
  final log = <MethodCall>[];

  StreamSubscription? _streamSubscription;

  EventChannelMock({
    required String channelName,
    required this.stream,
  }) : _methodChannel = MethodChannel(channelName) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_methodChannel, _handler);
  }

  Future<Object?> _handler(MethodCall methodCall) async {
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

    return null;
  }

  void _onListen() {
    _streamSubscription = stream.handleError((e) {
      _sendErrorEnvelope(e);
    }).listen(
      _sendSuccessEnvelope,
      onDone: () {
        _sendEnvelope(null);
      },
    );
  }

  void _onCancel() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
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

    final envelope = const StandardMethodCodec()
        .encodeErrorEnvelope(code: code, message: message, details: details);

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
