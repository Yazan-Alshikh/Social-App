import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_firebase/remote/network/social_cubit/cubit.dart';
import 'package:udemy_firebase/remote/network/social_cubit/state.dart';
import 'package:udemy_firebase/style/icon_broken.dart';
import 'package:udemy_firebase/widget/defaultformfiled.dart';

class UpdateProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = SocialCubit.get(context).userModel;
        var profileImage = SocialCubit.get(context).profileImage;
        var coverImage = SocialCubit.get(context).coverImage;

        nameController.text = model.name;
        phoneController.text = model.phone;
        bioController.text = model.bio;

        return Scaffold(
          appBar: AppBar(
            title: Text('Edit Your Profile'),
            titleSpacing: 5.0,
            actions: [
              TextButton(
                  onPressed: () {
                    SocialCubit.get(context).updateUser(
                        name: nameController.text,
                        phone: phoneController.text,
                        bio: bioController.text);
                    SocialCubit.get(context).uploadeProfileImage(
                        name: nameController.text,
                        phone: phoneController.text,
                        bio: bioController.text);
                    SocialCubit.get(context).uploadeCoverImage(
                        name: nameController.text,
                        phone: phoneController.text,
                        bio: bioController.text);
                  },
                  child: Text(
                    'Update',
                  )),
              SizedBox(
                width: 10,
              )
            ],
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(IconBroken.Arrow___Left_2)),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is GetUsersLoadingState)
                    LinearProgressIndicator(),
                  if (state is GetUsersLoadingState)
                    SizedBox(
                      height: 10,
                    ),
                  Container(
                    height: 325,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.topCenter,
                              child: Container(
                                height: 260,
                                width: double.infinity,
                                color: Colors.red,
                                child: Image(
                                  image: coverImage == null
                                      ? NetworkImage('${model.cover}')
                                      : FileImage(coverImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            InkWell(
                              child:
                                  CircleAvatar(child: Icon(IconBroken.Camera)),
                              onTap: () {
                                SocialCubit.get(context).getCoverImage();
                              },
                            ),
                          ],
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 72,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 70,
                                backgroundImage: profileImage == null
                                    ? NetworkImage('${model.image}')
                                    : FileImage(profileImage),
                              ),
                            ),
                            InkWell(
                              child:
                                  CircleAvatar(child: Icon(IconBroken.Camera)),
                              onTap: () {
                                SocialCubit.get(context).getProfileImage();
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  defaultFormfiled(
                      type: TextInputType.name,
                      validator: (String value) {
                        if (value.isEmpty) return 'Name Must Not Be Empty';
                        return null;
                      },
                      controller: nameController,
                      label: 'Name',
                      prefix: IconBroken.User),
                  SizedBox(
                    height: 15,
                  ),
                  defaultFormfiled(
                      type: TextInputType.phone,
                      validator: (String value) {
                        if (value.isEmpty) return 'Phone Must Not Be Empty';
                        return null;
                      },
                      controller: phoneController,
                      label: 'Phone',
                      prefix: IconBroken.Call),
                  SizedBox(
                    height: 15,
                  ),
                  defaultFormfiled(
                      type: TextInputType.text,
                      validator: (String value) {
                        if (value.isEmpty) return 'Bio Must Not Be Empty';
                        return null;
                      },
                      controller: bioController,
                      label: 'Bio',
                      prefix: IconBroken.Info_Square),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
