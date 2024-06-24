import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class MethodMock {
  final Duration delay;
  final String methodName;
  final dynamic result;

  const MethodMock({
    required this.methodName,
    this.delay = Duration.zero,
    this.result,
  });
}

class MethodChannelMock {
  final List<MethodMock> methods;
  final MethodChannel methodChannel;
  final log = <MethodCall>[];

  MethodChannelMock({
    required String channelName,
    required this.methods,
  }) : methodChannel = MethodChannel(channelName) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, _handler);
  }

  Future<dynamic> _handler(MethodCall methodCall) async {
    log.add(methodCall);

    final method = methods.firstWhere(
      (method) => method.methodName == methodCall.method,
      orElse: () => throw MissingPluginException(
        'No mock found for method ${methodCall.method} '
        'on channel ${methodChannel.name}',
      ),
    );

    return Future.delayed(method.delay, () {
      if (method.result is Exception) {
        throw method.result;
      }

      return Future.value(method.result);
    });
  }

  bool calledMethodName(String methodName) {
    return log.any((call) => call.method == methodName);
  }

  bool calledMethod(MethodCall method) {
    return log.any((call) => call == method);
  }
}
