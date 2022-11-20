import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motion/motion.dart';

import '../data/globals.dart';
import '../state/application/application_bloc.dart';

class RentalOverviewScreen extends StatelessWidget {
  const RentalOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    return BlocBuilder<ApplicationBloc, ApplicationState>(
      buildWhen: (previous, current) => previous != current && current is ApplicationUpdating,
      builder: (context, state) {
        return Container(
          color: Globals.sixtBlack,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 14.0, right: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text("BMW i4 M50", style: Globals.primaryTextStyle.copyWith(fontSize: 28)),
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1.0, color: applicationBloc.infoPillColor(applicationBloc.currentRentalState)),
                                  borderRadius: const BorderRadius.all(Radius.circular(12.0) //                 <--- border radius here
                                      ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8, bottom: 8),
                                  child: Text(applicationBloc.infoPillTitle(applicationBloc.currentRentalState),
                                      style: Globals.primaryTextStyle
                                          .copyWith(fontSize: 14, color: applicationBloc.infoPillColor(applicationBloc.currentRentalState))),
                                )),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Image.asset(
                        "assets/img/bmw-car.png",
                        width: 200,
                      ))
                ],
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                          backgroundColor: MaterialStateProperty.all(applicationBloc.primaryButtonColor(applicationBloc.currentRentalState)),
                        ),
                        onPressed: () {
                          applicationBloc.toggleStatus();
                          applicationBloc.add(UpdateScreenEvent());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            applicationBloc.primaryButtonTitle(applicationBloc.currentRentalState),
                            style: Globals.primaryTextStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        )),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                child: Row(children: [
                  CarFeature(
                      largeText: applicationBloc.currentCarRange(applicationBloc.currentRentalState),
                      smallText: "range",
                      icon: const Icon(size: 70, Icons.drive_eta)),
                  CarFeature(largeText: applicationBloc.currentChargeTime(applicationBloc.currentRentalState), smallText: "to full charge", icon: Icon(size: 70, Icons.battery_5_bar_outlined)),
                  CarFeature(
                      largeText: applicationBloc.currentCarDistance(applicationBloc.currentRentalState),
                      smallText: "northwest",
                      icon: Icon(size: 70, Icons.location_on)),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                child: Divider(
                  height: 10,
                  color: Colors.grey[700],
                ),
              ),
              if (applicationBloc.currentRentalState == RentalState.rented)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24),
                  child: Card(
                      elevation: 100,
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 22.0, top: 12, bottom: 4),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/img/sixt-logo-black.png",
                                    height: 32,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4, top: 6.0),
                                    child: Text(
                                      "FULL FLEX",
                                      style: Globals.primaryTextStyle.copyWith(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w900),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            AdvantageRow(
                                title: "Your GetGoing Status",
                                text:
                                    "You spent 25 minutes outside the city area during\nthis rental period.",
                                icon: Icon(
                                  Icons.attach_money,
                                  size: 0,
                                )),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      )),
                ),
              if (applicationBloc.currentRentalState == RentalState.postRental)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24),
                  child: Card(
                      elevation: 100,
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 22.0, top: 12, bottom: 4),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/img/sixt-logo-black.png",
                                    height: 32,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4, top: 6.0),
                                    child: Text(
                                      "FULL FLEX",
                                      style: Globals.primaryTextStyle.copyWith(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w900),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            AdvantageRow(
                                title: "You saved \$40 tonight!",
                                text: "HomeCharge charged for 351 minutes between\n10:51 PM and 6:25 AM.",
                                icon: Icon(
                                  Icons.attach_money,
                                  size: 0,
                                )),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      )),
                ),
              if (applicationBloc.currentRentalState == RentalState.charging)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24),
                  child: Card(
                      elevation: 100,
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 22.0, top: 12, bottom: 4),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/img/sixt-logo-black.png",
                                    height: 32,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4, top: 6.0),
                                    child: Text(
                                      "FULL FLEX",
                                      style: Globals.primaryTextStyle.copyWith(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w900),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            AdvantageRow(
                                title: "Nice work!",
                                text: "You contributed a total range of 4967km this month.",
                                icon: Icon(
                                  Icons.attach_money,
                                  size: 0,
                                )),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      )),
                ),
              if (applicationBloc.currentRentalState == RentalState.reserved)
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 260,
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: FullFlexCard(),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 12, bottom: 8),
                child: Text(
                  "Always included:",
                  style: Globals.primaryTextStyle.copyWith(fontSize: 24),
                ),
              ),
              Row(
                children: const [
                  Expanded(
                    child: AdvantageRow(
                      title: "Reservation",
                      text: "Up to 15 minutes",
                      icon: Icon(Icons.lock_clock),
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: AdvantageRow(
                      title: "Electricity",
                      text: "All yours",
                      icon: Icon(Icons.electric_bolt),
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: const [
                    Expanded(
                      child: AdvantageRow(
                        title: "Parking",
                        text: "No parking fees",
                        icon: Icon(Icons.local_parking),
                        textColor: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: AdvantageRow(
                        title: "Insurance",
                        text: "Liability coverage",
                        icon: Icon(CupertinoIcons.doc_append),
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class FullFlexCard extends StatelessWidget {
  const FullFlexCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 100,
      color: Globals.sixtOrange,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 12, bottom: 4),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/img/sixt-logo-black.png",
                      height: 32,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4, top: 6.0),
                      child: Text(
                        "FULL FLEX",
                        style: Globals.primaryTextStyle.copyWith(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w900),
                      ),
                    )
                  ],
                ),
              ),
              const AdvantageRow(
                title: "Full Flexibility",
                text: "Use any SIXT Share car, at any time.",
                icon: Icon(
                  Icons.check_sharp,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              const AdvantageRow(
                title: "GetGoing Guarantee",
                text: "Guaranteed ride into the city - and back home.",
                icon: Icon(
                  Icons.check_sharp,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              const AdvantageRow(
                title: "HomeCharge Advantage",
                text: "Charge your ride at home over night to save big.",
                icon: Icon(
                  Icons.check_sharp,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              const SizedBox(
                height: 22,
              )
            ],
          )
        ],
      ),
    );
  }
}

class AdvantageRow extends StatelessWidget {
  const AdvantageRow({Key? key, required this.title, required this.text, required this.icon, this.textColor = Colors.black}) : super(key: key);

  final String title;
  final String text;
  final Icon icon;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0, right: 8.0),
          child: icon,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Globals.primaryTextStyle.copyWith(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1.0, bottom: 2.0),
              child: Text(
                text,
                style: Globals.primaryTextStyle.copyWith(color: textColor, fontSize: 14),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class CarFeature extends StatelessWidget {
  const CarFeature({Key? key, required this.largeText, required this.smallText, required this.icon}) : super(key: key);

  final String largeText;
  final String smallText;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Stack(
            children: [
              Align(alignment: Alignment.topRight, child: Opacity(opacity: 0.2, child: icon)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 30,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Text(
                    largeText,
                    style: Globals.primaryTextStyle.copyWith(fontSize: 30),
                  ),
                  Text(
                    smallText,
                    style: Globals.primaryTextStyle.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
