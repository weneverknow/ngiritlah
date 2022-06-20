import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngiritlah/cache/app_cache.dart';
import 'package:ngiritlah/constants.dart';
import 'package:ngiritlah/database/database_service.dart';
import 'package:ngiritlah/pages/registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    DatabaseService.initDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/splashbg.png",
            fit: BoxFit.cover,
          ),
          Positioned(
              bottom: 0,
              child: Container(
                width: size.width,
                padding: const EdgeInsets.symmetric(
                    vertical: defaultPadding, horizontal: defaultPadding),
                //color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "N G I R I T l A H",
                      style: GoogleFonts.firaSans(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w100),
                    ),
                    const SizedBox(
                      height: defaultPadding / 2,
                    ),
                    Text(
                      "Catat dengan detail pengeluaranmu.",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(
                      height: defaultPadding * 1.5,
                    ),
                    Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: primaryColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.39, vertical: 14)),
                          onPressed: () async {
                            AppCache.saveAppStatus("registration");
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RegistrationScreen()));
                          },
                          child: Text("MULAI")),
                    ),
                    const SizedBox(
                      height: defaultPadding * 2,
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
