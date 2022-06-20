part of 'kategori_bloc.dart';

@immutable
abstract class KategoriState {}

class KategoriInitial extends KategoriState {}

class KategoriLoaded extends KategoriState {
  final List<Kategori> categories;
  KategoriLoaded(this.categories);
}
