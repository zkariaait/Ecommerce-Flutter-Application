import 'package:pfe_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:pfe_app/models/userr.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    lastName: '',
    emailId: '',
    mobileNo: '',
    password: '',
    address: '',
    type: '',
    token: '',
    //cart: [],
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(Userr userr) {
    _user = user;
    notifyListeners();
  }

  Userr _userr = Userr(
    id: '',
    name: '',
    lastName: '',
    emailId: '',
    mobileNo: '',
    password: '',
    address: '',
    type: '',
    token: '', cart: [],
    //cart: [],
  );

  Userr get userr => _userr;

  void setUserr(String userr) {
    _userr = Userr.fromJson(userr);
    notifyListeners();
  }

  void setUserrFromModel(Userr userr) {
    _userr = userr;
    notifyListeners();
  }
}
