part of 'application_bloc.dart';

@immutable
abstract class ApplicationEvent {}

class ChangeIndexEvent implements ApplicationEvent {
  final int index;
  ChangeIndexEvent({required this.index}) : super();
}

class ChangePlanEvent implements ApplicationEvent {
  final int index;
  ChangePlanEvent({required this.index}) : super();
}

// This is bad lmao
class UpdateScreenEvent implements ApplicationEvent {}
