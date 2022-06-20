import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngiritlah/bloc/kategori_bloc.dart';
import 'package:ngiritlah/bloc/user_bloc.dart';
import 'package:ngiritlah/cache/app_cache.dart';
import 'package:ngiritlah/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ngiritlah/database/database_service.dart';
import 'package:ngiritlah/database/kategori_database_service.dart';
import 'package:ngiritlah/database/transaksi_database_service.dart';
import 'package:ngiritlah/pages/home_screen.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import '../bloc/validation_bloc.dart';
import '../database/user_database_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _salaryController =
      MoneyMaskedTextController(precision: 0, decimalSeparator: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(
                0, defaultPadding * 2, defaultPadding, defaultPadding / 4),
            width: 180,
            height: 140,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/teller.jpg"),
                    fit: BoxFit.contain)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(defaultPadding,
                defaultPadding / 2, defaultPadding, defaultPadding / 4),
            child: Text("Halo Bosque,",
                style: GoogleFonts.sourceSansPro(
                    color: primaryColor,
                    fontSize: 42,
                    fontWeight: FontWeight.w100)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Text(
              "Kenalan dulu yuk!",
              style: TextStyle(
                  color: primaryColor.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
          ),
          const SizedBox(
            height: defaultPadding * 2,
          ),
          BlocBuilder<ValidationBloc, ValidationState>(
            builder: (context, state) {
              bool isNameValid = true;
              if (state is UpdatedValidation) {
                isNameValid = state.validation.isNameValid ?? true;
              }

              return buildInput("Nama Pengguna",
                  hintText: "Elon Musk",
                  icon: Icons.person_outline_rounded,
                  controller: _nameController,
                  errorText: (isNameValid) ? "" : "Nama Pengguna harus diisi.");
            },
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          BlocBuilder<ValidationBloc, ValidationState>(
            builder: (context, state) {
              bool isSalaryValid = true;
              if (state is UpdatedValidation) {
                isSalaryValid = state.validation.isSalaryValid ?? true;
              }
              return buildInput("Gaji Saat Ini",
                  hintText: "8.000.000",
                  textAlign: TextAlign.end,
                  textInputType: TextInputType.number,
                  icon: Icons.monetization_on_outlined,
                  controller: _salaryController,
                  errorText: isSalaryValid ? "" : "Gaji Saat Ini harus diisi");
            },
          ),
          const SizedBox(
            height: defaultPadding * 2,
          ),
          Flexible(
              child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 15)),
                    onPressed: () async {
                      print(double.tryParse(_salaryController.text) ?? 0);
                      context.read<ValidationBloc>().add(CheckValidation(
                          username: _nameController.text,
                          salary:
                              double.tryParse(_salaryController.text) ?? 0));
                      final isvalid = await validation();

                      if (isvalid) {
                        await AppCache.saveAppStatus(
                            "loggedin"); //save already logged in status to cache

                        await UserDatabaseService
                            .createTable(); //create user table
                        await KategoriDatabaseService
                            .createTable(); //create kategori table
                        await TransaksiDatabaseService
                            .createTable(); //create transaksi table

                        await UserDatabaseService.insert(
                            _nameController.text,
                            double.tryParse(_salaryController.text) ??
                                0); //insert user

                        context.read<UserBloc>().add(LoadUser());
                        context.read<KategoriBloc>().add(LoadKategori());

                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => HomeScreen()));
                      }
                    },
                    child: Text("MASUK")),
              )
            ],
          ))
        ],
      )),
    );
  }

  Future<bool> validation() async {
    var salary = double.tryParse(_salaryController.text) ?? 0;
    bool isValid = !(_nameController.text.isEmpty || salary <= 0);
    return isValid;
  }

  Widget buildInput(String label,
      {String? hintText,
      TextAlign textAlign = TextAlign.start,
      TextInputType? textInputType,
      IconData icon = Icons.circle_outlined,
      TextEditingController? controller,
      String errorText = "",
      Function(String?)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w200),
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          TextField(
            keyboardType: textInputType,
            textAlign: textAlign,
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              focusColor: primaryColor,
              hintText: hintText,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(right: defaultPadding / 2),
                child: Icon(
                  icon,
                  color: Colors.black,
                ),
              ),
              prefixIconConstraints:
                  BoxConstraints(minHeight: 20, minWidth: 20),
              hintStyle: TextStyle(
                  fontStyle: FontStyle.italic, color: Colors.grey.shade300),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryColor.withOpacity(0.2))),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryColor)),
            ),
          ),
          const SizedBox(
            height: defaultPadding / 4,
          ),
          errorText.isEmpty
              ? const SizedBox.shrink()
              : Text(
                  errorText,
                  style: TextStyle(
                      color: Colors.red,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500),
                )
        ],
      ),
    );
  }
}
