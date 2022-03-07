import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_firebase/constanc/constanc.dart';
import 'package:udemy_firebase/remote/local/cache_helper.dart';
import 'package:udemy_firebase/remote/network/social_cubit/cubit.dart';
import 'package:udemy_firebase/remote/observer_cubit.dart';
import 'package:udemy_firebase/screen/login_screen.dart';
import 'package:udemy_firebase/screen/social_layout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  uId = (CacheHelper.getData(key: 'uId')) as String;
  Widget widget;

  if (uId != null)
    widget = SocialLayout();
  else
    widget = LoginScreen();

  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  MyApp({this.startWidget});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SocialCubit()..getUsers()..getPost(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: Colors.deepOrange,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              elevation: 20,
            ),
            primaryColor: Colors.deepOrange,
            primarySwatch: Colors.deepOrange,
            scaffoldBackgroundColor: Colors.white,
            textTheme: TextTheme(
                subtitle1: TextStyle(
                  fontSize: 18,
                ),
                caption: TextStyle(fontSize: 14)),
            textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(TextStyle(color: Colors.black)),
                    overlayColor: MaterialStateProperty.all(Colors.grey[100]))),
            appBarTheme: AppBarTheme(
                elevation: 0,
                color: Colors.white,
                titleTextStyle: TextStyle(color: Colors.black),
                iconTheme: IconThemeData(color: Colors.black)),
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
                style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all(Colors.grey[100])))),
        themeMode: ThemeMode.light,
        home: startWidget,
      ),
    );
  }
}
