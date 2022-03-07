import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_firebase/model/message_model.dart';
import 'package:udemy_firebase/model/users_model.dart';
import 'package:udemy_firebase/remote/network/social_cubit/cubit.dart';
import 'package:udemy_firebase/remote/network/social_cubit/state.dart';
import 'package:udemy_firebase/style/icon_broken.dart';

class ChatDetalisScreen extends StatelessWidget {
  UsersModel usersModel;
  ChatDetalisScreen({this.usersModel});

  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMessage(receiverid: usersModel.uid);

        return BlocConsumer<SocialCubit, SocialState>(
          listener: (context, state) {
            if (state is SendMessageSuccessState)
              textController.text = '';
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage('${usersModel.image}'),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      usersModel.name,
                      style: Theme.of(context).textTheme.subtitle1,
                    )
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var message = SocialCubit.get(context).message[index];
                          if (message.senderid ==
                              SocialCubit.get(context).userModel.uid)
                            return buildMyMessage(message);
                          return buildMessage(message);
                        },
                        separatorBuilder: (context, index) => SizedBox(
                          height: 10,
                        ),
                        itemCount: SocialCubit.get(context).message.length,
                      ),
                    ),
                    Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300], width: 1.0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                controller: textController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'write your message'),
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              SocialCubit.get(context).sendMessage(
                                  receiverid: usersModel.uid,
                                  text: textController.text,
                                  datetime: DateTime.now().toString());
                            },
                            child: Icon(
                              IconBroken.Send,
                              color: Colors.white,
                            ),
                            minWidth: 1,
                            height: 50,
                            color: Colors.deepOrange,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.topStart,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(10),
                topEnd: Radius.circular(10),
                topStart: Radius.circular(10),
              )),
          child: Text(model.text),
        ),
      );
  Widget buildMyMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.topEnd,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadiusDirectional.only(
                bottomStart: Radius.circular(10),
                topStart: Radius.circular(10),
                topEnd: Radius.circular(10),
              )),
          child: Text(model.text),
        ),
      );
}
