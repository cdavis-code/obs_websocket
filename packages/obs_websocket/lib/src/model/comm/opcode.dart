import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:obs_websocket/obs_websocket.dart';

part 'opcode.g.dart';

@JsonSerializable()
class Opcode {
  final int op;
  final Map<String, dynamic> d;

  Opcode({required this.op, required this.d});

  factory Opcode.fromJson(Map<String, dynamic> json) => _$OpcodeFromJson(json);

  Map<String, dynamic> toJson() => _$OpcodeToJson(this);

  @override
  String toString() => json.encode(toJson());
}

class HelloOpcode extends Opcode {
  final Hello hello;

  HelloOpcode(this.hello)
    : super(op: WebSocketOpCode.hello.code, d: hello.toJson());

  factory HelloOpcode.fromJson(Map<String, dynamic> json) =>
      HelloOpcode(Hello.fromJson(json['d']));
}

class IdentifyOpcode extends Opcode {
  final Identify identify;

  IdentifyOpcode(this.identify)
    : super(op: WebSocketOpCode.identify.code, d: identify.toJson());
}

class ReIdentifyOpcode extends Opcode {
  final ReIdentify reIdentify;

  ReIdentifyOpcode(this.reIdentify)
    : super(op: WebSocketOpCode.reIdentify.code, d: reIdentify.toJson());
}

class EventOpcode extends Opcode {
  final Event event;

  EventOpcode(this.event)
    : super(op: WebSocketOpCode.event.code, d: event.toJson());
}

class RequestOpcode extends Opcode {
  final Request request;

  RequestOpcode(this.request)
    : super(op: WebSocketOpCode.request.code, d: request.toJson());
}

class RequestResponseOpcode extends Opcode {
  final RequestResponse requestResponse;

  RequestResponseOpcode(this.requestResponse)
    : super(
        op: WebSocketOpCode.requestResponse.code,
        d: requestResponse.toJson(),
      );
}

class RequestBatchOpcode extends Opcode {
  final RequestBatch requestBatch;

  RequestBatchOpcode(this.requestBatch)
    : super(op: WebSocketOpCode.requestBatch.code, d: requestBatch.toJson());
}

class RequestBatchResponseOpcode extends Opcode {
  final RequestBatch requestBatchResponse;

  RequestBatchResponseOpcode(this.requestBatchResponse)
    : super(
        op: WebSocketOpCode.requestBatchResponse.code,
        d: requestBatchResponse.toJson(),
      );
}
