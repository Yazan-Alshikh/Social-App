import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_firebase/remote/network/login_cubit/states.dart';

class LoginCubit extends Cubit<LoginStatus> {
  LoginCubit() : super(LoginInitialStatue());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool ispassword = true;
  IconData suffix = Icons.visibility_off;

  void showPassword() {
    ispassword = !ispassword;
    suffix = ispassword ? Icons.visibility_off : Icons.visibility;
    emit(LoginShowPasswordStatue());
  }

  void usersLogin({@required String email, @required String password}) {
    emit(LoginLoadingStatue());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user.email);
      print(value.user.uid);
      emit(LoginSuccessStatue(value.user.uid));
    }).catchError((error) {
      print(error.toString());
      emit(LoginErrorStatue());
    });
  }
}
