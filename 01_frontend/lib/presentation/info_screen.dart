import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sixt_hackatum/presentation/rental_overview_screen.dart';

import '../data/globals.dart';
import '../state/application/application_bloc.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreen();
}

class _InfoScreen extends State<InfoScreen> {
  double _currentSliderValue = 20;

  // TODO
  @override
  Widget build(BuildContext context) {
    ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    return BlocBuilder<ApplicationBloc, ApplicationState>(
      builder: (context, state) {
        return Container(
          color: Globals.sixtBlack,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 16, bottom: 16, left: 16, right: 16),
              child: const FullFlexCard(),
            ),
            (_currentSliderValue == 0 || _currentSliderValue == 24)
                ? const SizedBox(width: 200.0, height: 300.0)
                : SizedBox(
                    width: 200.0,
                    height: 300.0,
                    child: PieChart(PieChartData(
                        centerSpaceRadius: 10,
                        borderData: FlBorderData(show: false),
                        sections: [
                          PieChartSectionData(
                              value: (24 - _currentSliderValue),
                              color: const Color(0xfffffff),
                              radius: 110,
                              title: (((24 - _currentSliderValue).round()).toString() +
                                  '\nhours \n Charging')),
                          PieChartSectionData(
                              value: _currentSliderValue,
                              color: const Color(0xffFF5F00),
                              radius: 110,
                              title: _currentSliderValue.round().toString() +
                                  '\nhours \n Usage'),
                        ]))),
            Slider(
              value: _currentSliderValue,
              max: 24,
              divisions: 5,
              label: _currentSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
            ),
            Row(children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: const Text('share car'),
                    margin: const EdgeInsets.only(left: 7.0),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    child: const Text('SIXT+'),
                    margin: const EdgeInsets.only(right: 7.0),
                  ),
                ),
              ),
            ]

                // Get values from bloc using applicationBloc.plan
                // Force rebuild by sending ApplicationEvent -> handle in Bloc (see other events)
                ),
            StrikeThroughWidget(
              child: (_currentSliderValue == 24 || _currentSliderValue == 0)
                  ? const Text('')
                  : const Text("\$829", style: TextStyle(fontSize: 30)),
            ),
            (_currentSliderValue == 0)
                ? const Text(
                    'Please have a look on the individual share fees',
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  )
                : Text(
                    "\$" +
                        (829 - ((24 - _currentSliderValue) * 5))
                            .round()
                            .toString(),
                    style: const TextStyle(fontSize: 50)),
          ]),
        );
      },
    );
  }
}

class StrikeThroughWidget extends StatelessWidget {
  final Widget _child;

  StrikeThroughWidget({Key? key, required Widget child})
      : this._child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _child,
      padding: const EdgeInsets.symmetric(
          horizontal:
              8), // this line is optional to make strikethrough effect outside a text
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/img/strike.png'), fit: BoxFit.fitWidth),
      ),
    );
  }
}
