import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_firebase/remote/network/register_cubit/cubit.dart';
import 'package:udemy_firebase/remote/network/register_cubit/states.dart';
import 'package:udemy_firebase/screen/social_layout_screen.dart';
import 'package:udemy_firebase/widget/defaultbutton.dart';
import 'package:udemy_firebase/widget/defaultformfiled.dart';

class RegisterScreen extends StatelessWidget {
  var namecontroller = TextEditingController();
  var emailcontroller = TextEditingController();
  var phonecontroller = TextEditingController();
  var passwordcontroller = TextEditingController();

  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStatus>(
        listener: (context, state) {
          if (state is GreatUsersSuccessState) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SocialLayout()),
                (route) => false);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Form(
                  key: formkey,
                  child: Column(
                    children: [
                      defaultFormfiled(
                          type: TextInputType.name,
                          validator: (String value) {
                            if (value.isEmpty) return 'Name must not bee empty';
                            return null;
                          },
                          controller: namecontroller,
                          label: 'Name',
                          prefix: Icons.person),
                      SizedBox(
                        height: 15,
                      ),
                      defaultFormfiled(
                          type: TextInputType.emailAddress,
                          validator: (String value) {
                            if (value.isEmpty)
                              return 'Email must not bee empty';
                            return null;
                          },
                          controller: emailcontroller,
                          label: 'Email Address',
                          prefix: Icons.email_outlined),
                      SizedBox(
                        height: 15,
                      ),
                      defaultFormfiled(
                          type: TextInputType.phone,
                          validator: (String value) {
                            if (value.isEmpty) return 'Phone required';
                            return null;
                          },
                          controller: phonecontroller,
                          label: 'Phone',
                          prefix: Icons.phone),
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
                          ispassword: RegisterCubit.get(context).ispassword,
                          suffix: RegisterCubit.get(context).suffix,
                          onsuffixpreesed: () {
                            RegisterCubit.get(context).showPassword();
                          },
                          onsubmit: (String value) {
                            if (formkey.currentState.validate()) {
                              RegisterCubit.get(context).usersRegister(
                                  email: emailcontroller.text,
                                  name: namecontroller.text,
                                  phone: phonecontroller.text,
                                  password: passwordcontroller.text);
                            }
                          },
                          prefix: Icons.lock),
                      SizedBox(
                        height: 15,
                      ),
                      ConditionalBuilder(
                        condition: state is! RegisterLoadingStatue,
                        builder: (context) => defaultbutton(
                            onPressed: () {
                              if (formkey.currentState.validate()) {
                                RegisterCubit.get(context).usersRegister(
                                    email: emailcontroller.text,
                                    name: namecontroller.text,
                                    phone: phonecontroller.text,
                                    password: passwordcontroller.text);
                              }
                            },
                            text: 'register'),
                        fallback: (context) => Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
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
