import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ngiritlah/bloc/kategori_bloc.dart';
import 'package:ngiritlah/bloc/transaksi_bloc.dart';
import 'package:ngiritlah/bloc/user_bloc.dart';
import 'package:ngiritlah/bloc/validation_bloc.dart';
import 'package:ngiritlah/pages/home_screen.dart';
import 'package:ngiritlah/pages/registration_screen.dart';
import 'package:ngiritlah/pages/welcome_screen.dart';
import 'cache/app_cache.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ValidationBloc()),
        BlocProvider(create: (_) => UserBloc()),
        BlocProvider(create: (_) => KategoriBloc()..add(LoadKategori())),
        BlocProvider(create: (_) => TransaksiBloc()..add(LoadTransaksi()))
      ],
      child: MaterialApp(
          title: 'Ngirit App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: FutureBuilder(
              future: AppCache.getAppStatus(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    if (snapshot.data == "") {
                      return WelcomeScreen();
                    } else if (snapshot.data == "registration") {
                      return RegistrationScreen();
                    } else if (snapshot.data == "loggedin") {
                      context.read<UserBloc>().add(LoadUser());
                      return HomeScreen();
                    }
                  }
                  return WelcomeScreen();
                }
                return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                );
              })),
    );
  }
}
