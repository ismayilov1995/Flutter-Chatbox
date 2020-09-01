import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_chatbox/common_widget/responsive_alertdialog.dart';
import 'package:flutter_chatbox/common_widget/social_login_button.dart';
import 'package:flutter_chatbox/viewmodel/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File _profilePhoto;
  TextEditingController _usernameCtrl;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _usernameCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserViewmodel _userVM = Provider.of<UserViewmodel>(context);
    _usernameCtrl.text = _userVM.user.username;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _confirmSignOut(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child:
                    Stack(alignment: AlignmentDirectional.bottomEnd, children: [
                  CircleAvatar(
                    radius: 75.0,
                    backgroundImage: _profilePhoto == null
                        ? NetworkImage(_userVM.user.profileUrl)
                        : FileImage(_profilePhoto),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(40)),
                    child: IconButton(
                      icon: Icon(Icons.photo_camera),
                      iconSize: 36,
                      onPressed: () => _pickImageModal(_userVM),
                    ),
                  )
                ]),
              ),
              Text(
                _usernameCtrl.text,
                style: Theme.of(context).textTheme.headline4,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  initialValue: _userVM.user.email,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: "Email", border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
                child: TextFormField(
                  controller: _usernameCtrl,
                  decoration: InputDecoration(
                      labelText: "Username", border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
                child: SocialLoginButton(
                  buttonText: "Save changes",
                  onPressed: () {
                    _updateUsername(context, _userVM);
                    _updateProfilePhoto(_userVM);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _signOut(BuildContext context) async {
    final _userVM = Provider.of<UserViewmodel>(context, listen: false);
    await _userVM.signOut();
  }

  void _confirmSignOut(BuildContext context) async {
    final allow = await ResponsiveAlertDialog(
      title: "Sure?",
      content: "Are you sure logout application?",
      allowBtn: "I'm sure",
      cancelBtn: "Cancel",
    ).show(context);
    if (allow) {
      _signOut(context);
    }
  }

  void _updateUsername(BuildContext context, UserViewmodel _userModel) async {
    if (_userModel.user.username != _usernameCtrl.text) {
      if (await _userModel.updateUserName(
          _userModel.user.userID, _usernameCtrl.text)) {
        _userModel.user.username = _usernameCtrl.text;
      } else {
        ResponsiveAlertDialog(
          title: "Warning",
          content: "Username already in use, try with difference",
          allowBtn: "Ok",
        ).show(context);
      }
    }
  }

  void _pickImageModal(UserViewmodel userVM) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Wrap(
              children: [
                Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text("Take new one"),
                      onTap: () => _pickImage(ImageSource.camera),
                    ),
                    ListTile(
                      leading: Icon(Icons.image),
                      title: Text("Choose from gallery"),
                      onTap: () => _pickImage(ImageSource.gallery),
                    ),
                    ListTile(
                      leading: Icon(Icons.cancel),
                      title: Text("Cancel"),
                    ),
                  ],
                )
              ],
            ));
  }

  void _pickImage(ImageSource source) async {
    final _picker = ImagePicker();
    var _pickedImage = await _picker.getImage(source: source);
    if (_pickedImage != null) {
      setState(() {
        _profilePhoto = File(_pickedImage.path);
      });
      Navigator.of(context).pop();
    }
  }

  void _updateProfilePhoto(UserViewmodel userVM) async {
    if (_profilePhoto == null) return;
    var url = await userVM.uploadImage(
        userVM.user.userID, 'profile_photo', _profilePhoto);
    if (url != null) {
      _profilePhoto = null;
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Image is updated successfuly"),
      ));
    }
  }
}
