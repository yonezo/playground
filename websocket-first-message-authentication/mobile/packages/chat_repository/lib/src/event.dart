import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

@Freezed(unionKey: 'type', unionValueCase: FreezedUnionCase.snake)
class Event with _$Event {
  const factory Event.message({
    required String text,
    required String uid,
  }) = EventMessage;

  const factory Event.authentication({
    required String token,
  }) = EventAuthentication;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
