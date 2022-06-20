import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ngiritlah/models/validation.dart';

part 'validation_event.dart';
part 'validation_state.dart';

class ValidationBloc extends Bloc<ValidationEvent, ValidationState> {
  ValidationBloc() : super(ValidationInitial()) {
    on<ValidationEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<CheckValidation>((event, emit) {
      Validation validation = Validation(
          isNameValid: event.username.isNotEmpty,
          isSalaryValid: event.salary > 0);
      emit(UpdatedValidation(validation));
    });
  }
}
