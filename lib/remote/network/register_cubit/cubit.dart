import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_firebase/model/users_model.dart';
import 'package:udemy_firebase/remote/network/register_cubit/states.dart';

class RegisterCubit extends Cubit<RegisterStatus> {
  RegisterCubit() : super(RegisterInitialStatue());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool ispassword = true;
  IconData suffix = Icons.visibility_off;

  void showPassword() {
    ispassword = !ispassword;
    suffix = ispassword ? Icons.visibility_off : Icons.visibility;
    emit(RegisterShowPasswordStatue());
  }

  void usersRegister(
      {@required String email,
      @required String password,
      @required String phone,
      @required String name}) {
    emit(RegisterLoadingStatue());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user.email);
      print(value.user.uid);
      createUsers(email: email, uid: value.user.uid, phone: phone, name: name);
      emit(RegisterSuccessStatue());
    }).catchError((error) {
      print(error.toString());
      emit(RegisterErrorStatue());
    });
  }

  void createUsers(
      {@required String email,
      @required String uid,
      @required String phone,
      @required String name}) {
    UsersModel model = UsersModel(
        email: email,
        name: name,
        phone: phone,
        uid: uid,
        image:
            'https://image.freepik.com/free-photo/waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer_273609-16320.jpg',
        bio: 'write you bio....',
        cover:
            'https://img.freepik.com/free-photo/satisfied-student-posing-against-pink-wall_273609-20219.jpg?size=338&ext=jpg');
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(model.ToMap())
        .then((value) {
      emit(GreatUsersSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GreatUsersErrorState());
    });
  }
}
