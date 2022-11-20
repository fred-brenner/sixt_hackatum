import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/application/application_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    return BlocBuilder<ApplicationBloc, ApplicationState>(
      builder: (context, state) {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 70, left: 8, right: 8),
                child: TextFormField(
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(), labelText: 'First Name'),
                )),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(), labelText: 'Last Name'),
                )),
            Row(children: [
              SizedBox(width: 8), // Use this to add some space
              SizedBox(
                  width: 250,
                  child: TextFormField(
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(), labelText: 'Street'),
                  )),
              SizedBox(width: 16), // Use this to add some space
              SizedBox(
                  width: 150,
                  child: TextFormField(
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Street Number'),
                  )),
            ]),
            Row(children: [
              SizedBox(width: 8),
              SizedBox(
                  width: 150,
                  child: TextFormField(
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Postal Code'),
                  )),
              SizedBox(width: 16), // Use this to add some space
              SizedBox(
                  width: 250,
                  child: TextFormField(
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(), labelText: 'City'),
                  ))
            ]),
            SizedBox(height: 20),
            Text('When will you usually recharge the car?',
                style: TextStyle(fontSize: 30), textAlign: TextAlign.center),
            Row(children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      'Start time of recharging',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    margin: EdgeInsets.only(left: 7.0),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    child: Text(
                      'End time of recharging',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    margin: EdgeInsets.only(right: 7.0),
                  ),
                ),
              ),
            ]

                // Get values from bloc using applicationBloc.plan
                // Force rebuild by sending ApplicationEvent -> handle in Bloc (see other events)
                ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    width: 200.0,
                    height: 150.0,
                    child: TimePickerPage(),
                  ),
                  SizedBox(
                    width: 200.0,
                    height: 150.0,
                    child: TimePickerPage(),
                  )
                ])
          ],
        ));
      },
    );
  }
}

class TimePickerPage extends StatefulWidget {
  const TimePickerPage({Key? key}) : super(key: key);

  @override
  State<TimePickerPage> createState() => _TimePickerPageState();
}

class _TimePickerPageState extends State<TimePickerPage> {
  TimeOfDay timeOfDay = TimeOfDay.now();
  @override
  Widget build(BuildContext context) {
    final hours = timeOfDay.hour.toString().padLeft(2, '0');
    final minutes = timeOfDay.minute.toString().padLeft(2, '0');
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$hours:$minutes',
              style:
                  const TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () async {
                TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: timeOfDay,
                    initialEntryMode: TimePickerEntryMode.input);
                if (newTime == null) return;
                setState(() {
                  timeOfDay = newTime;
                });
              },
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Select a Time",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w800),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
