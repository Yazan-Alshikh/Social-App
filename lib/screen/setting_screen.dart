import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_firebase/remote/network/social_cubit/cubit.dart';
import 'package:udemy_firebase/remote/network/social_cubit/state.dart';
import 'package:udemy_firebase/screen/update_profile_screen.dart';
import 'package:udemy_firebase/style/icon_broken.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = SocialCubit.get(context).userModel;
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: 325,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topCenter,
                        child: Container(
                          height: 260,
                          width: double.infinity,
                          color: Colors.red,
                          child: Image(
                            image: NetworkImage('${model.cover}'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 72,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage('${model.image}'),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${model.name}",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  '${model.bio}',
                  style: Theme.of(context).textTheme.caption,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [Text('100'), Text('Post')],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [Text('252'), Text('Photo')],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [Text('10k'), Text('Followers')],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [Text('58'), Text('Following')],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                        child: OutlinedButton(
                      onPressed: () {},
                      child: Text(
                        'Add Photo',
                        style: Theme.of(context).textTheme.button,
                      ),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateProfileScreen(),
                              ));
                        },
                        child: Icon(
                          IconBroken.Edit,
                          size: 28,
                          color: Colors.black,
                        ))
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
