import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_firebase/remote/network/social_cubit/cubit.dart';
import 'package:udemy_firebase/remote/network/social_cubit/state.dart';
import 'package:udemy_firebase/screen/add_post_screen.dart';
import 'package:udemy_firebase/style/icon_broken.dart';

class SocialLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        if(state is AddPostScreenState)
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostScreen(),));
      },
      builder: (context, state) {
        var get = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              get.label[get.currentindex],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(IconBroken.Notification)),
              IconButton(onPressed: () {}, icon: Icon(IconBroken.Search)),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: get.item,
            onTap: (int index) {
              get.changenavbar(index);
            },
            currentIndex: get.currentindex,
          ),
          body: get.screens[get.currentindex],
        );
      },
    );
  }
}
