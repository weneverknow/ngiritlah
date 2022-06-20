import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ngiritlah/database/kategori_database_service.dart';
import 'package:ngiritlah/models/kategori.dart';

part 'kategori_event.dart';
part 'kategori_state.dart';

class KategoriBloc extends Bloc<KategoriEvent, KategoriState> {
  KategoriBloc() : super(KategoriInitial()) {
    on<KategoriEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<LoadKategori>((event, emit) async {
      final categories = await KategoriDatabaseService.get();
      emit(KategoriLoaded(categories ?? []));
    });
  }
}
