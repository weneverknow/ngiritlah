part of 'transaksi_bloc.dart';

@immutable
abstract class TransaksiState {}

class TransaksiInitial extends TransaksiState {}

class TransaksiLoaded extends TransaksiState {
  final List<Transaksi> transactions;
  TransaksiLoaded(this.transactions);
}
