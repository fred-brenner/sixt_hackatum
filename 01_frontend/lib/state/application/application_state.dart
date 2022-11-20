part of 'application_bloc.dart';

@immutable
abstract class ApplicationState {}

class ApplicationInitial extends ApplicationState {}

class ApplicationUpdating extends ApplicationState {}
