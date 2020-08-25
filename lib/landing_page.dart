import 'package:flutter/material.dart';
import 'package:flutter_chatbox/viewmodel/user_model.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'sign_in_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userVM = Provider.of<UserViewmodel>(context);
    if (_userVM.state == ViewState.IDLE) {
      if (_userVM.user == null) {
        return SignInPage();
      } else {
        return HomePage(
          user: _userVM.user,
        );
      }
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).cardColor,
        child: Center(child: CircularProgressIndicator()),
      );
    }
  }
}
