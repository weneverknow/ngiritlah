part of 'validation_bloc.dart';

@immutable
abstract class ValidationEvent {}

class CheckValidation extends ValidationEvent {
  final String username;
  final double salary;
  CheckValidation({required this.username, required this.salary});
}
