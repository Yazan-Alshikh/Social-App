import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_firebase/model/post_model.dart';
import 'package:udemy_firebase/remote/network/social_cubit/cubit.dart';
import 'package:udemy_firebase/remote/network/social_cubit/state.dart';
import 'package:udemy_firebase/style/icon_broken.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: ConditionalBuilder(
            condition: SocialCubit.get(context).posts.length > 0 &&
                SocialCubit.get(context).userModel != null,
            fallback: (context) => Center(child: CircularProgressIndicator()),
            builder: (context) => SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Card(
                    elevation: 5,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Image(
                          image: NetworkImage(
                              'https://img.freepik.com/free-photo/satisfied-student-posing-against-pink-wall_273609-20219.jpg?size=338&ext=jpg'),
                          fit: BoxFit.cover,
                          height: 300,
                          width: double.infinity,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            'communicate with frindes',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => BuildHomeItem(
                          SocialCubit.get(context).posts[index],
                          context,
                          index),
                      separatorBuilder: (context, index) => SizedBox(
                            height: 20,
                          ),
                      itemCount: SocialCubit.get(context).posts.length)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget BuildHomeItem(PostModel model, context, index) => Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage('${model.image}'),
                      radius: 25,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${model.name}',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          '${model.datetime}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${model.text}',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              // Wrap(
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 10),
              //       child: Container(
              //         height: 20,
              //         child: MaterialButton(
              //           minWidth: 1,
              //           padding: EdgeInsets.zero,
              //           onPressed: () {},
              //           child: Text(
              //             '#software',
              //             style: TextStyle(color: Colors.blue),
              //           ),
              //         ),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 10),
              //       child: Container(
              //         height: 20,
              //         child: MaterialButton(
              //           minWidth: 1,
              //           padding: EdgeInsets.zero,
              //           onPressed: () {},
              //           child: Text(
              //             '#flutter',
              //             style: TextStyle(color: Colors.blue),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              if (model.postimage != ' ')
                Image(
                  image: NetworkImage('${model.postimage}'),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 250,
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          IconBroken.Heart,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text('${SocialCubit.get(context).like[index]}'),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(
                          IconBroken.Chat,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text('0 comment'),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    InkWell(
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                '${SocialCubit.get(context).userModel.image}'),
                            radius: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'write a comment ...',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                      onTap: () {},
                    ),
                    Spacer(),
                    InkWell(
                      child: Row(
                        children: [
                          Icon(
                            IconBroken.Heart,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Like')
                        ],
                      ),
                      onTap: () {
                        SocialCubit.get(context)
                            .getLike(SocialCubit.get(context).postid[index]);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
