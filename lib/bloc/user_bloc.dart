import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ngiritlah/models/user.dart';

import '../database/user_database_service.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UserEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<LoadUser>((event, emit) async {
      final user = await UserDatabaseService.get();
      emit(UserLoaded(user));
    });
  }
}
