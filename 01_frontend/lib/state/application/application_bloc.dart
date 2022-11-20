import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'dart:ui' as ui;

import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../data/globals.dart';

part 'application_event.dart';

part 'application_state.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  // Currently selected index of BottomNavigationBar
  int currentNavigationIndex = 1;

  // Current rental state
  RentalState currentRentalState = RentalState.reserved;

  // Currently selected pricing tier
  int currentPlan = 0;

  // Walkthrough is:
  // - Reserved car at MUC Freiheit
  // - Open drawer, tap on unlock
  // - Car is in unlocked state (show car in profile?), tap on Navigator -> go home
  // - Tap on lock, go to HomeCharging state

  // Various rotating state variables
  String primaryButtonTitle(RentalState state) {
    if (state == RentalState.reserved) return "UNLOCK";
    if (state == RentalState.rented) return "END RENTAL";
    if (state == RentalState.charging) return "CHARGING";
    if (state == RentalState.postRental) return "UNLOCK";
    return "LOADING";
  }
  String infoPillTitle(RentalState state) {
    if (state == RentalState.reserved) return "Reserved";
    if (state == RentalState.rented) return "Rented";
    if (state == RentalState.charging) return "HomeCharging";
    if (state == RentalState.postRental) return "Reserved";
    return "Loading";
  }
  Color infoPillColor(RentalState state) {
    if (state == RentalState.reserved) return Colors.grey;
    if (state == RentalState.rented) return Globals.sixtOrange;
    if (state == RentalState.charging) return Colors.green;
    if (state == RentalState.postRental) return Colors.grey;
    return Globals.sixtOrange;
  }
  Color primaryButtonColor(RentalState state) {
    if (state == RentalState.reserved) return Globals.sixtOrange;
    if (state == RentalState.rented) return Colors.red;
    if (state == RentalState.charging) return Colors.green;
    if (state == RentalState.postRental) return Globals.sixtOrange;
    return Globals.sixtOrange;
  }
  String currentCarRange(RentalState state) {
    if (state == RentalState.reserved) return "83km";
    if (state == RentalState.rented) return "82km";
    if (state == RentalState.charging) return "100km";
    if (state == RentalState.postRental) return "659km";
    return "404km";
  }
  String currentChargeTime(RentalState state) {
    if (state == RentalState.reserved) return "7h 20m";
    if (state == RentalState.rented) return "7h 22m";
    if (state == RentalState.charging) return "6h 30m";
    if (state == RentalState.postRental) return "1h 32m";
    return "404km";
  }
  String currentCarDistance(RentalState state) {
    if (state == RentalState.reserved) return "650m";
    if (state == RentalState.rented) return "0m";
    if (state == RentalState.charging) return "20m";
    if (state == RentalState.postRental) return "4m";
    return "404km";
  }


  // Controller for SlidingUpPanel
  PanelController panelController = PanelController();

  // Set of all markers added to map
  Set<Marker> markers = {};

  // Add location markers to map (must be done asynchronous due to assets)
  addMarkers() async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/img/car-icon.png', 130);
    BitmapDescriptor otherCars = BitmapDescriptor.fromBytes(markerIcon);
    final Uint8List locationIcon = await getBytesFromAsset('assets/img/own-location.png', 100);
    BitmapDescriptor personalLocation = BitmapDescriptor.fromBytes(locationIcon);
    final Uint8List reservedLocationIcon = await getBytesFromAsset('assets/img/car-icon-selected.png', 145);
    BitmapDescriptor reservedLocation = BitmapDescriptor.fromBytes(reservedLocationIcon);
    List<LatLng> coordinates = [
      const LatLng(48.1451348636098, 11.567886666437264),
      const LatLng(48.14159827949371, 11.582177728337998),
    ];
    for (LatLng coordinate in coordinates) {
      markers.add(Marker(
        markerId: MarkerId(coordinate.toString()),
        position: coordinate,
        onTap: () => panelController.open(),
        icon: otherCars, //Icon for Marker
      ));
    }
    List<LatLng> reservedLocationLats = [
      const LatLng(48.14659548715418, 11.579356493521786),

    ];
    for (LatLng reservedLocationLat in reservedLocationLats) {
      markers.add(Marker(
        markerId: MarkerId(reservedLocation.toString()),
        position: reservedLocationLat,
        onTap: () {
          // TODO
          panelController.open();
        },
        icon: reservedLocation, //Icon for Marker
      ));
    }
    for (CameraPosition location in locations) {
      // Personal location marker
      markers.add(Marker(
        markerId: MarkerId(location.toString()),
        position: location.target,
        onTap: () {
          // TODO
          panelController.open();
        },
        icon: personalLocation, //Icon for Marker
      ));
    }
  }

  int currentLocation = 0;
  final List<CameraPosition> locations = [
    // Odeonsplatz
    const CameraPosition(
      target: LatLng(48.14294438915797, 11.577006563815647),
      zoom: 14.6746,
    ),
    // Moosinning
    const CameraPosition(
      target: LatLng(48.289214094208816, 11.781571985088233),
      zoom: 14.6746,
    ),
  ];
  GoogleMapController? mapsController;

  ApplicationBloc() : super(ApplicationInitial()) {
    on<ApplicationEvent>((event, emit) {});

    on<ChangeIndexEvent>((event, emit) {
      currentNavigationIndex = event.index;
      emit(ApplicationUpdating());
      emit(ApplicationInitial());
    });

    on<ChangePlanEvent>((event, emit) {
      // TODO: If any data needs to be updated, so so here.
      print("New plan selected: ${event.index}");
      emit(ApplicationUpdating());
      emit(ApplicationInitial());
    });

    on<UpdateScreenEvent>((event, emit) {
      emit(ApplicationUpdating());
      emit(ApplicationInitial());
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  updateLocation() {
    currentLocation = (currentLocation + 1) % locations.length;
    mapsController?.animateCamera(CameraUpdate.newCameraPosition(locations[currentLocation]));
  }

  centerLocation() {
    mapsController?.animateCamera(CameraUpdate.newCameraPosition(locations[currentLocation]));
  }

  // TODO
  updateCar() {
    currentLocation = (currentLocation + 1) % locations.length;
    mapsController?.animateCamera(CameraUpdate.newCameraPosition(locations[currentLocation]));
  }

  toggleStatus() {
    if (currentRentalState == RentalState.reserved) {
      currentRentalState = RentalState.rented;
      return;
    }
    if (currentRentalState == RentalState.rented) {
      currentRentalState = RentalState.charging;
      return;
    }
    if (currentRentalState == RentalState.charging) {
      currentRentalState = RentalState.postRental;
      return;
    }
    if (currentRentalState == RentalState.postRental) {
      currentRentalState = RentalState.reserved;
      return;
    }
  }
}
