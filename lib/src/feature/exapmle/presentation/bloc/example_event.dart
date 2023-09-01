part of 'example_bloc.dart';

@freezed
class ExampleEvent with _$ExampleEvent {
  const factory ExampleEvent.started() = _Started;
}