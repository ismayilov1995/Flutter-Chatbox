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
  bool _hasMore = true;
  static final _limit = 10;
  ChatViewState _state = ChatViewState.IDLE;

  UserRepository _userRepository = locator<UserRepository>();

  ChatViewmodel({@required this.sender, @required this.receiver}) {
    _messages = [];
    getPaginatedMessages();
  }

  List<Message> get messages => _messages;

  ChatViewState get state => _state;

  bool get hasMore => _hasMore;

  set state(ChatViewState value) {
    _state = value;
    notifyListeners();
  }

  Future<bool> sendMessage(Message message) async {
    return await _userRepository.sendMessage(message);
  }

  Future<void> getPaginatedMessages() async {
    if (_messages.length > 0)
      _lastMessage = _messages.last;
    else
      state = ChatViewState.BUSY;
    var newMessages = await _userRepository.getPaginatedMessages(
        sender.userID, receiver.userID, _lastMessage, _limit);
    if (newMessages.length < _limit)
      _hasMore = false;
    _messages.addAll(newMessages);
    state = ChatViewState.IDLE;
  }

  Future<void> loadOldMessages() async {
    if (_hasMore) await getPaginatedMessages();
  }
}
