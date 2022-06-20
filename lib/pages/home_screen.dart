import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ngiritlah/bloc/transaksi_bloc.dart';
import 'package:ngiritlah/constants.dart';
import 'package:ngiritlah/database/database_service.dart';
import 'package:intl/intl.dart';
import 'package:ngiritlah/database/kategori_database_service.dart';
import 'package:ngiritlah/database/transaksi_database_service.dart';
import 'package:ngiritlah/models/kategori.dart';
import 'package:ngiritlah/models/transaksi.dart';
import 'package:ngiritlah/pages/components/dashboard_header.dart';
import '../bloc/kategori_bloc.dart';
import '../bloc/user_bloc.dart';
import '../database/user_database_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _kategoriController = TextEditingController();
  final _nominalController = TextEditingController();
  final _keteranganController = TextEditingController();

  @override
  void initState() {
    //load();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _kategoriController.dispose();
    _nominalController.dispose();
    _keteranganController.dispose();
    //Fluttertoast.cancel();
  }

  load() async {
    final user = await UserDatabaseService.get();
    print(user);
    setState(() {
      name = user.name ?? '-';
      salary = user.salary ?? 0;
    });
  }

  String name = "";
  double salary = 0;
  List categories = ["Kategori 1", "Kategori 2"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: defaultPadding,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: DashboardHeader()),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding),
              child: Row(
                children: [
                  buildCardBalance("Gaji anda :", "salary"),
                  const SizedBox(
                    width: defaultPadding / 2,
                  ),
                  buildCardBalance("Sisa saldo :", "balance"),
                ],
              ),
            ),
            Container(
              height: 10,
              color: Color(0xff585858).withOpacity(0.3),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            buildKategoriTitle(),
            const SizedBox(
              height: defaultPadding / 2,
            ),
            Flexible(child: BlocBuilder<KategoriBloc, KategoriState>(
              builder: (context, state) {
                if (state is KategoriLoaded) {
                  var items = state.categories;
                  if (items.isEmpty) {
                    return buildEmptyKategori();
                  }
                  return DefaultTabController(
                      length: items.length,
                      child: Column(
                        children: [
                          Container(
                            child: TabBar(
                                labelColor: Colors.black,
                                indicatorColor: primaryColor,
                                tabs: items
                                    .map((e) => Tab(
                                          text: e.name,
                                        ))
                                    .toList()),
                          ),
                          Flexible(
                              child: Container(
                            child: TabBarView(
                                children:
                                    items.map((e) => buildContent(e)).toList()),
                          ))
                        ],
                      ));
                }
                return Container();
              },
            ))
          ],
        ),
      ),
    );
  }

  Align buildEmptyKategori() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: defaultPadding * 2),
        child: Text(
          "Belum ada kategori.\nsilakan tambahkan kategori",
          style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 178, 177, 177),
              fontWeight: FontWeight.w300),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildContent(Kategori kategori) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: defaultPadding / 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildKategoriBalanceCard('Saldo', kategori.nominal!),
                  buildKategoriBalanceCard('Sisa Saldo', kategori.balance!)
                ],
              ),
              const SizedBox(
                height: defaultPadding / 2,
              ),
              Flexible(child: BlocBuilder<TransaksiBloc, TransaksiState>(
                builder: (context, state) {
                  if (state is TransaksiLoaded) {
                    var transactions = state.transactions;
                    if (transactions.isEmpty) {
                      return Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Tidak ada transaksi",
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      );
                    }
                    transactions = transactions
                        .where((element) => element.idKategori == kategori.id)
                        .toList();
                    return ListView(
                        children: transactions
                            .map((e) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: defaultPadding,
                                      vertical: defaultPadding / 2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${e.keterangan}"),
                                      Text(
                                        NumberFormat.currency(
                                          locale: 'id_IDR',
                                          symbol: '',
                                          decimalDigits: 2,
                                        ).format(e.nominal),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                ))
                            .toList());
                  }
                  return Container();
                },
              ))
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding * 2, vertical: 14)),
                  onPressed: () {
                    addPengeluaran(kategori);
                  },
                  label: Text("PENGELUARAN ${kategori.name!.toUpperCase()}"),
                  icon: Icon(Icons.add),
                ),
                const SizedBox(
                  height: defaultPadding,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  addPengeluaran(Kategori kategori) {
    _kategoriController.text = (kategori.name ?? '-').toUpperCase();
    _keteranganController.clear();
    _nominalController.clear();
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Tambah Pengeluaran",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    buildInput('Kategori',
                        controller: _kategoriController,
                        icon: Icons.category_rounded,
                        readOnly: true),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    buildInput('Keterangan',
                        icon: Icons.shopping_bag_rounded,
                        controller: _keteranganController),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    buildInput('Nominal',
                        icon: Icons.monetization_on_rounded,
                        textAlign: TextAlign.end,
                        textInputType: TextInputType.number,
                        controller: _nominalController),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    Flexible(
                        child: ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  primary: primaryColor),
                              onPressed: () {
                                print("kategori ${kategori.name}");
                                print(
                                    "keterangan ${_keteranganController.text}");
                                print("nominal ${_nominalController.text}");
                                Transaksi data = Transaksi(
                                    idKategori: kategori.id,
                                    keterangan: _keteranganController.text,
                                    nominal: double.tryParse(
                                            _nominalController.text) ??
                                        0,
                                    createdDate: DateTime.now());
                                insertPengeluaran(data, kategori);
                              },
                              child: Text("SIMPAN PENGELUARAN")),
                        )
                      ],
                    ))
                  ],
                ),
              ),
            ));
  }

  insertPengeluaran(Transaksi transaksi, Kategori kategori) async {
    if (transaksi.nominal! > (kategori.balance ?? 0)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Nominal pengeluaran lebih besar dari sisa saldo!")));
      return;
    }
    final insert = await TransaksiDatabaseService.insert(transaksi, kategori);
    print("insert $insert");
    if (insert) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: 'Pengeluaran berhasil ditambahkan',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Color.fromARGB(255, 28, 28, 28),
          textColor: Colors.white,
          fontSize: 16);
      context.read<KategoriBloc>()..add(LoadKategori());
      context.read<TransaksiBloc>().add(LoadTransaksi());
    } else {
      Fluttertoast.cancel();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Pengeluaran gagal ditambahkan!")));
    }
    //Navigator.pop(context);
  }

  Flexible buildKategoriBalanceCard(String title, double nominal) {
    return Flexible(
      fit: FlexFit.tight,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
        margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.3),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$title",
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w300),
            ),
            const SizedBox(
              height: defaultPadding / 4,
            ),
            Text(
              NumberFormat.currency(locale: 'id_IDR', decimalDigits: 2)
                  .format(nominal),
              style: TextStyle(fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }

  addKategori() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                      child: Text(
                    "Tambah Kategori Pengeluaran",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  )),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  buildInput("Kategori",
                      icon: Icons.category_outlined,
                      hintText: "Belanja Harian",
                      controller: _kategoriController),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  buildInput("Saldo",
                      textAlign: TextAlign.end,
                      icon: Icons.monetization_on_outlined,
                      hintText: NumberFormat.currency(
                              locale: 'id_ID', symbol: 'IDR ', decimalDigits: 2)
                          .format(1500000),
                      controller: _nominalController),
                  const SizedBox(
                    height: defaultPadding * 2,
                  ),
                  Flexible(
                      child: ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () async {
                              if (_kategoriController.text.isEmpty ||
                                  _nominalController.text.isEmpty) {
                                return;
                              }

                              Kategori kategori = Kategori(
                                name: _kategoriController.text,
                                nominal:
                                    double.tryParse(_nominalController.text) ??
                                        0,
                                balance:
                                    double.tryParse(_nominalController.text) ??
                                        0,
                              );

                              final insert =
                                  await KategoriDatabaseService.insert(
                                      kategori);

                              if (insert > 0) {
                                context
                                    .read<KategoriBloc>()
                                    .add(LoadKategori());
                              }

                              print("insert $insert");

                              print(
                                  "${_kategoriController.text} ${_nominalController.text}");
                              // setState(() {
                              //   categories
                              //       .add("Kategori ${categories.length + 1}");
                              // });
                              Navigator.of(context).pop();
                            },
                            child: Text("TAMBAH KATEGORI")),
                      )
                    ],
                  ))
                ],
              ),
            ),
          );
        });
  }

  Widget buildInput(String label,
      {String? hintText,
      TextAlign textAlign = TextAlign.start,
      TextInputType? textInputType,
      IconData icon = Icons.circle_outlined,
      TextEditingController? controller,
      String errorText = "",
      bool readOnly = false}) {
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
            readOnly: readOnly,
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

  Widget buildKategoriTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Kategori Pengeluaran",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          GestureDetector(
            onTap: () {
              print("add kategori");
              _kategoriController.clear();
              _nominalController.clear();
              addKategori();
            },
            child: Row(
              children: [
                Icon(
                  Icons.add_rounded,
                  color: primaryColor,
                  size: 14,
                ),
                const SizedBox(
                  width: defaultPadding / 4,
                ),
                Text(
                  "Kategori",
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.w600),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Flexible buildCardBalance(String title, String type) {
    return Flexible(
      fit: FlexFit.tight,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xff585858), width: 0.2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 12,
                  fontWeight: FontWeight.w300),
            ),
            const SizedBox(
              height: defaultPadding / 2,
            ),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoaded) {
                  return Text(
                    type == "salary"
                        ? "${NumberFormat.currency(locale: 'id_IDR', symbol: 'IDR ', decimalDigits: 2).format(state.user.salary)}"
                        : "${NumberFormat.currency(locale: 'id_IDR', symbol: 'IDR ', decimalDigits: 2).format(state.user.salaryBalance)}",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  );
                }
                return const SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }
}
