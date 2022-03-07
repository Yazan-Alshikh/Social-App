import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_firebase/model/users_model.dart';
import 'package:udemy_firebase/remote/network/social_cubit/cubit.dart';
import 'package:udemy_firebase/remote/network/social_cubit/state.dart';
import 'package:udemy_firebase/screen/chat_detalis_screen.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: ConditionalBuilder(
            condition: SocialCubit.get(context).users.length > 0,
            builder: (context) => ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) => builedChatItem(
                  SocialCubit.get(context).users[index], context),
              separatorBuilder: (context, index) => Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey,
              ),
              itemCount: SocialCubit.get(context).users.length,
            ),
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  Widget builedChatItem(UsersModel model, context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatDetalisScreen(usersModel: model,)));
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage('${model.image}'),
                radius: 25,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '${model.name}',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
        ),
      );
}
