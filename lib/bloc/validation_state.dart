part of 'validation_bloc.dart';

@immutable
abstract class ValidationState {}

class ValidationInitial extends ValidationState {}

class UpdatedValidation extends ValidationState {
  final Validation validation;
  UpdatedValidation(this.validation);
}
