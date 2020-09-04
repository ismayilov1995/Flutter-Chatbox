import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_chatbox/models/message.dart';
import 'package:flutter_chatbox/models/user.dart';
import 'package:flutter_chatbox/repository/user_repository.dart';

import '../locator.dart';

enum ChatViewState { IDLE, BUSY }

class ChatViewmodel with ChangeNotifier {
  final AppUser sender, receiver;
  List<Message> _messages;
  Message _lastMessage;
  Message _firstMessageAddedList;
  bool _hasMore = true;
  static final _limit = 10;
  bool _realTimeMessageListener = false;
  StreamSubscription _subscription;

  ChatViewState _state = ChatViewState.IDLE;

  UserRepository _userRepository = locator<UserRepository>();

  ChatViewmodel({@required this.sender, @required this.receiver}) {
    _messages = [];
    getPaginatedMessages();
  }

  @override
  dispose() {
    _subscription.cancel();
    super.dispose();
  }

  List<Message> get messages => _messages;

  ChatViewState get state => _state;

  bool get hasMore => _hasMore;

  set state(ChatViewState value) {
    _state = value;
    notifyListeners();
  }

  Future<bool> sendMessage(Message message) async {
    return await _userRepository.sendMessage(message, sender);
  }

  Future<void> getPaginatedMessages() async {
    if (_messages.length > 0) {
      _lastMessage = _messages.last;
    } else
      state = ChatViewState.BUSY;

    var newMessages = await _userRepository.getPaginatedMessages(
        sender.userID, receiver.userID, _lastMessage, _limit);

    if (newMessages.length < _limit) _hasMore = false;
    _messages.addAll(newMessages);

    if (_messages.length > 0) _firstMessageAddedList = _messages.first;

    state = ChatViewState.IDLE;

    if (!_realTimeMessageListener) {
      _realTimeMessageListener = true;
      addNewMessageListener();
    }
  }

  Future<void> loadOldMessages() async {
    if (_hasMore) await getPaginatedMessages();
  }

  void addNewMessageListener() {
    _subscription = _userRepository
        .getChatMessages(sender.userID, receiver.userID)
        .listen((event) {
      if (event.isNotEmpty) {
        if (event[0].createdAt != null) {
          if (_firstMessageAddedList == null) {
            _messages.insert(0, event[0]);
          } else if (_firstMessageAddedList.createdAt.millisecondsSinceEpoch !=
              event[0].createdAt.millisecondsSinceEpoch)
            _messages.insert(0, event[0]);
        }
        state = ChatViewState.IDLE;
      }
    });
  }
}
