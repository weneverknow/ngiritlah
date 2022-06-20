import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ngiritlah/database/transaksi_database_service.dart';
import 'package:ngiritlah/models/transaksi.dart';

part 'transaksi_event.dart';
part 'transaksi_state.dart';

class TransaksiBloc extends Bloc<TransaksiEvent, TransaksiState> {
  TransaksiBloc() : super(TransaksiInitial()) {
    on<TransaksiEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<LoadTransaksi>((event, emit) async {
      final items = await TransaksiDatabaseService.get();
      emit(TransaksiLoaded(items));
    });
  }
}
