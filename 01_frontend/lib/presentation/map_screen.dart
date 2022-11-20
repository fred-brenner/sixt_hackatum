import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixt_hackatum/presentation/rental_overview_screen.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../data/globals.dart';
import '../state/application/application_bloc.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    return BlocBuilder<ApplicationBloc, ApplicationState>(
      builder: (context, state) {
        return SlidingUpPanel(
          minHeight: 150,
          maxHeight: 770,
          controller: applicationBloc.panelController,
          panel: GestureDetector(
            onTap: () {
              if (applicationBloc.panelController.isPanelOpen) {
                applicationBloc.panelController.close();
                applicationBloc.centerLocation();
              } else {
                applicationBloc.panelController.open();
              }
            },
            child: const RentalOverviewScreen(),
          ),
          body: Center(
            child: Stack(
              children: [
                GoogleMap(
                  markers: applicationBloc.markers,
                  initialCameraPosition: applicationBloc
                      .locations[applicationBloc.currentLocation],
                  onMapCreated: (GoogleMapController controller) async {
                    applicationBloc.mapsController = controller;
                    applicationBloc.mapsController
                        ?.setMapStyle(Globals.darkMapStyle);
                    await applicationBloc.addMarkers();
                    applicationBloc.add(UpdateScreenEvent());
                  },
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 80.0, right: 8),
                      child: Column(
                        children: [
                          SizedBox(
                              height: 45,
                              width: 45,
                              child: FloatingActionButton(
                                onPressed: () =>
                                    applicationBloc.updateLocation(),
                                foregroundColor: Colors.white,
                                backgroundColor: Globals.sixtBlack,
                                elevation: 5,
                                child: const Icon(Icons.navigation),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: SizedBox(
                                height: 45,
                                width: 45,
                                child: FloatingActionButton(
                                  onPressed: () {applicationBloc.centerLocation();},
                                  foregroundColor: Colors.white,
                                  backgroundColor: Globals.sixtBlack,
                                  child: const Icon(Icons.search),
                                )),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}
