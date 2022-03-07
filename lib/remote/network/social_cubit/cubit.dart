import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:udemy_firebase/constanc/constanc.dart';
import 'package:udemy_firebase/model/message_model.dart';
import 'package:udemy_firebase/model/post_model.dart';
import 'package:udemy_firebase/model/users_model.dart';
import 'package:udemy_firebase/remote/network/social_cubit/state.dart';
import 'package:udemy_firebase/screen/add_post_screen.dart';
import 'package:udemy_firebase/screen/chat_screen.dart';
import 'package:udemy_firebase/screen/home_screen.dart';
import 'package:udemy_firebase/screen/setting_screen.dart';
import 'package:udemy_firebase/screen/users_screen.dart';
import 'package:udemy_firebase/style/icon_broken.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialState> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  UsersModel userModel;

  void getUsers() {
    emit(GetUsersLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UsersModel.fromjson(value.data());
      emit(GetUsersSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetUsersErrorState());
    });
  }

  int currentindex = 0;

  List<String> label = ['Home', 'Chats', 'post', 'Users', 'Settings'];

  List<Widget> screens = [
    HomeScreen(),
    ChatScreen(),
    AddPostScreen(),
    UsersScreen(),
    SettingScreen()
  ];

  List<BottomNavigationBarItem> item = [
    BottomNavigationBarItem(icon: Icon(IconBroken.Home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(IconBroken.Chat), label: 'Chats'),
    BottomNavigationBarItem(icon: Icon(IconBroken.Paper_Upload), label: 'Post'),
    BottomNavigationBarItem(icon: Icon(IconBroken.Location), label: 'Users'),
    BottomNavigationBarItem(icon: Icon(IconBroken.Setting), label: 'Settings'),
  ];

  void changenavbar(int index) {
    if (index == 1) getAllUsers();

    if (index == 2) {
      emit(AddPostScreenState());
    } else {
      currentindex = index;
      emit(ChangeNavBarItemState());
    }
  }

  File profileImage;
  var picker = ImagePicker();

  Future getProfileImage() async {
    final pikedFile = await picker.getImage(source: ImageSource.gallery);
    if (pikedFile != null) {
      profileImage = File(pikedFile.path);
      emit(GetProfileImageSuccessState());
    } else {
      print('no image selected');
      emit(GetProfileImageErrorState());
    }
  }

  File coverImage;

  Future getCoverImage() async {
    final pikedFile = await picker.getImage(source: ImageSource.gallery);
    if (pikedFile != null) {
      coverImage = File(pikedFile.path);
      emit(GetCoverImageSuccessState());
    } else {
      print('no image selected');
      emit(GetCoverImageErrorState());
    }
  }

  String profileImageUrl = '';
  void uploadeProfileImage({
    String name,
    String phone,
    String bio,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage.path).pathSegments.last}')
        .putFile(profileImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        profileImageUrl = value;
        updateUser(name: name, phone: phone, bio: bio, image: profileImageUrl);
        emit(UploadCoverImageSuccessState());
      }).onError((error, stackTrace) {
        emit(UploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(UploadCoverImageErrorState());
    });
  }

  String coverImageUrl = '';
  void uploadeCoverImage({
    String name,
    String phone,
    String bio,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage.path).pathSegments.last}')
        .putFile(coverImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        coverImageUrl = value;
        updateUser(name: name, phone: phone, bio: bio, cover: coverImageUrl);
        emit(UploadCoverImageSuccessState());
      }).onError((error, stackTrace) {
        emit(UploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(UploadCoverImageErrorState());
    });
  }

  File postImage;

  Future getPostImage() async {
    final pikedFile = await picker.getImage(source: ImageSource.gallery);
    if (pikedFile != null) {
      postImage = File(pikedFile.path);
      emit(GetPostImageSuccessState());
    } else {
      print('no image selected');
      emit(GetPostImageErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(RemovePostImageState());
  }

  void updateUser({
    String name,
    String phone,
    String bio,
    String image,
    String cover,
  }) {
    UsersModel model = UsersModel(
      email: userModel.email,
      name: name,
      phone: phone,
      uid: userModel.uid,
      image: image ?? userModel.image,
      bio: bio,
      cover: cover ?? userModel.cover,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uid)
        .update(model.ToMap())
        .then((value) {
      getUsers();
    }).catchError((error) {
      emit(UpdateUsersErrorState());
    });
  }

  void uploadePostImage({
    @required String text,
    @required String datetime,
  }) {
    emit(UpdatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage.path).pathSegments.last}')
        .putFile(postImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(text: text, datetime: datetime, postimage: value);
        emit(UploadPostImageSuccessState());
      }).onError((error, stackTrace) {
        emit(UploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(UploadPostImageErrorState());
    });
  }

  void createPost(
      {@required String text, @required String datetime, String postimage}) {
    emit(UpdatePostLoadingState());
    PostModel model = PostModel(
      name: userModel.name,
      uid: userModel.uid,
      image: userModel.image,
      text: text,
      datetime: datetime,
      postimage: postimage ?? ' ',
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.ToMap())
        .then((value) {
      emit(UpdatePostSuccessState());
    }).catchError((error) {
      emit(UpdatePostErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postid = [];
  List<int> like = [];

  void getPost() {
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          like.add(value.docs.length);
          postid.add(element.id);
          posts.add(PostModel.fromjson(element.data()));
          emit(GetPostsSuccessState());
        }).catchError((error) {});
      });
      emit(GetPostsSuccessState());
    }).catchError((error) {
      emit(GetPostsErrorState());
    });
  }

  void getLike(String postid) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postid)
        .collection('likes')
        .doc(userModel.uid)
        .set({'like': true}).then((value) {
      emit(GetLikeSuccessState());
    }).catchError((error) {
      emit(GetLikeErrorState());
    });
  }

  List<UsersModel> users = [];

  void getAllUsers() {
    if (users.length == 0)
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uid'] != userModel.uid)
            users.add(UsersModel.fromjson(element.data()));
        });
        emit(GetAllUsersSuccessState());
      }).catchError((error) {
        emit(GetAllUsersErrorState());
      });
  }

  void sendMessage(
      {@required String receiverid,
      @required String text,
      @required String datetime}) {
    MessageModel model = MessageModel(
        datetime: datetime,
        text: text,
        receiverid: receiverid,
        senderid: userModel.uid);

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uid)
        .collection('chats')
        .doc(receiverid)
        .collection('messages')
        .add(model.ToMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverid)
        .collection('chats')
        .doc(userModel.uid)
        .collection('messages')
        .add(model.ToMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });
  }

  List<MessageModel> message = [];

  void getMessage({@required String receiverid}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uid)
        .collection('chats')
        .doc(receiverid)
        .collection('messages')
        .orderBy('datetime')
        .snapshots()
        .listen((event) {
      message = [];
      event.docs.forEach((element) {
        message.add(MessageModel.fromjson(element.data()));
      });
      emit(GetMessageSuccessState());
    });
  }
}
