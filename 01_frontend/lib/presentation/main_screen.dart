import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sixt_hackatum/presentation/info_screen.dart';
import 'package:sixt_hackatum/presentation/map_screen.dart';
import 'package:sixt_hackatum/presentation/profile_screen.dart';

import '../data/globals.dart';
import '../state/application/application_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    return BlocBuilder<ApplicationBloc, ApplicationState>(
      buildWhen: (previous, current) =>
          previous != current && current is ApplicationUpdating,
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              if (applicationBloc.currentNavigationIndex == 0)
                SafeArea(
                  bottom: false,
                  child: SizedBox(
                    // Hardcoded height: BottomNavigationBar + NotificationArea
                    height: MediaQuery.of(context).size.height - (90 + 59),
                    width: double.maxFinite,
                    child: const InfoScreen(),
                  ),
                ),
              if (applicationBloc.currentNavigationIndex == 1)
                SizedBox(
                  height: MediaQuery.of(context).size.height - 90,
                  width: double.maxFinite,
                  child: const MapScreen(),
                ),
              if (applicationBloc.currentNavigationIndex == 2)
                SizedBox(
                  height: MediaQuery.of(context).size.height - (90),
                  width: double.maxFinite,
                  child: const ProfileScreen(),
                ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              applicationBloc.add(ChangeIndexEvent(index: index));
            },
            currentIndex: applicationBloc.currentNavigationIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.info_outline,
                ),
                label: 'My Plan',
                activeIcon: Icon(Icons.info_outline),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                ),
                label: 'Drive',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outline,
                  color: Colors.white,
                ),
                label: 'Account',
                activeIcon: Icon(Icons.person_outline),
                backgroundColor: Globals.sixtOrange,
              ),
            ],
            backgroundColor: Globals.sixtBlack,
          ),
        );
      },
    );
  }
}
