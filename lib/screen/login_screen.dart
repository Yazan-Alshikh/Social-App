import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_firebase/constanc/constanc.dart';
import 'package:udemy_firebase/remote/local/cache_helper.dart';
import 'package:udemy_firebase/remote/network/login_cubit/cubit.dart';
import 'package:udemy_firebase/remote/network/login_cubit/states.dart';
import 'package:udemy_firebase/screen/register_screen.dart';
import 'package:udemy_firebase/screen/social_layout_screen.dart';
import 'package:udemy_firebase/widget/defaultbutton.dart';
import 'package:udemy_firebase/widget/defaultformfiled.dart';

class LoginScreen extends StatelessWidget {
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();

  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStatus>(
        listener: (context, state) {
          if (state is LoginSuccessStatue) {
            CacheHelper.setData(key: 'uId', value: state.uId).then((value) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SocialLayout()),
                  (route) => false);
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Login to socialapp',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        defaultFormfiled(
                            type: TextInputType.emailAddress,
                            validator: (String value) {
                              if (value.isEmpty)
                                return 'Email must not bee empty';
                              return null;
                            },
                            controller: emailcontroller,
                            label: 'Email',
                            prefix: Icons.email_outlined),
                        SizedBox(
                          height: 15,
                        ),
                        defaultFormfiled(
                            type: TextInputType.visiblePassword,
                            validator: (String value) {
                              if (value.isEmpty) return 'Password is too short';
                              return null;
                            },
                            controller: passwordcontroller,
                            label: 'Password',
                            prefix: Icons.lock,
                            onsuffixpreesed: () {
                              LoginCubit.get(context).showPassword();
                            },
                            onsubmit: (String value) {
                              if (formkey.currentState.validate()) {
                                LoginCubit.get(context).usersLogin(
                                    email: emailcontroller.text,
                                    password: passwordcontroller.text);
                              }
                            },
                            ispassword: LoginCubit.get(context).ispassword,
                            suffix: LoginCubit.get(context).suffix),
                        SizedBox(
                          height: 15,
                        ),
                        ConditionalBuilder(
                          builder: (context) => defaultbutton(
                              onPressed: () {
                                if (formkey.currentState.validate()) {
                                  if (formkey.currentState.validate()) {
                                    LoginCubit.get(context).usersLogin(
                                        email: emailcontroller.text,
                                        password: passwordcontroller.text);
                                  }
                                }
                              },
                              text: 'login'),
                          condition: state is! LoginLoadingStatue,
                          fallback: (context) => Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account'),
                            SizedBox(
                              width: 7,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterScreen()));
                                },
                                child: Text('Register'.toUpperCase())),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
