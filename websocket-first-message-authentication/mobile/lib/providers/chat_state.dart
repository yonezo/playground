import 'package:flutter/foundation.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  factory ChatState({
    @Default(false) bool isReady,
    @Default([]) List<TextMessage> messages,
  }) = _ChatState;
}
