import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sixt_hackatum/presentation/main_screen.dart';
import 'package:sixt_hackatum/state/application/application_bloc.dart';

import 'data/globals.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white, // this one for android
      statusBarBrightness: Brightness.dark // this one for iOS
      ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
        primaryColor: Globals.sixtOrange,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: Globals.sixtOrange,
            unselectedItemColor: Colors.white,
            selectedLabelStyle:
                Globals.primaryTextStyle.copyWith(color: Globals.sixtOrange),
            unselectedLabelStyle:
                Globals.primaryTextStyle.copyWith(color: Colors.white),
            showUnselectedLabels: true),
      ),
      //themeMode: ThemeMode.dark,
      home: Scaffold(
        body: BlocProvider(
          create: (context) => ApplicationBloc(),
          child: Container(color: Globals.sixtBlack, child: const MainScreen()),
        ),
      ),
    );
  }
}
