import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:manager/ui/equity.dart';
import 'package:manager/ui/mpesa.dart';
import 'package:button_navigation_bar/button_navigation_bar.dart';

import '../model/gettextfield.dart';
import 'package:intl/intl.dart';

import 'login.dart';

class Sales extends StatefulWidget {
  String User;
  Sales({Key? key, required this.User}) : super(key: key);

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  String dat = DateFormat('yyyy-MM-dd KK:mm').format(DateTime.now());

  TextEditingController phonetec = TextEditingController();
  TextEditingController mphonetec = TextEditingController();
  TextEditingController salestec = TextEditingController();
  TextEditingController destec = TextEditingController();

  void _sendSMS(String message, List<String> recipents) async {
    await sendSMS(message: message, recipients: recipents, sendDirect: true)
        .catchError((onError) {
      // print(onError);
    });
//print(resultb);
  }

  Future<dynamic> submitData() async {
    var url = Uri.parse('https://basemanager.herokuapp.com/sales.php');
    var phones = phonetec.text.toString();
    var mphones = mphonetec.text.toString();
    var sales = salestec.text.toString();
    var description = destec.text.toString();

    var response = await http.post(url, body: {
      "user": widget.User,
      "phones": phones,
      "mphones": mphones,
      "sales": sales,
      "description": description
    });

    var data = json.decode(response.body);
    if (data == "error") {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        headerAnimationLoop: false,
        title: 'Error',
        desc: 'Error Occured.. Please try Again',
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red,
      ).show();
    } else if (data == "dbconnerr") {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        headerAnimationLoop: false,
        title: 'DB Error',
        desc: 'Error Occured.. Please try Again',
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red,
      ).show();
    } else {
      AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        showCloseIcon: true,
        title: 'Success',
        desc: 'Todays Data Submitted Successful',
        btnOkOnPress: () {
          String message =
              "${widget.User}. Has sent likoni original phones shop manager data. $dat ";
          List<String> recipents = ["+254718901248"];
          _sendSMS(
            message,
            recipents,
          );
        },
        btnOkIcon: Icons.check_circle,
        onDismissCallback: (type) {
          //debugPrint('Dialog Dissmiss from callback $type');
        },
      ).show();
    }
  }

  late Future<List> userdetails;

  @override
  void initState() {
    super.initState();
    userdetails = getUser(widget.User);
  }

  final formkey = GlobalKey<FormState>();
  final formkeyb = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double containerHeight = MediaQuery.of(context).size.height * 5 / 14;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
          future: userdetails,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return WillPopScope(
                onWillPop: () async {
                  _asyncExitConfirmDialog(context);
                  return false;
                },
                child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  body: Center(
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50)),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(255, 248, 134, 1),
                                Color.fromARGB(240, 114, 182, 1)
                              ])),
                          width: MediaQuery.of(context).size.width,
                          //height: containerHeight,
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 1 / 17,
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      'HOME',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    Text(dat),
                                    IconButton(
                                        onPressed: () {
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title: const Text('LOGOUT'),
                                              content: const Text(
                                                  'Are you sure you want to logout?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login(),));
                                                    Navigator.of(context)
                                                        .pushAndRemoveUntil(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const Login()),
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false);
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "LOGOUT SUCCESSFUL");
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, 'Cancel');
                                                    },
                                                    child: const Text("Cancel"))
                                              ],
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.logout),
                                        tooltip: 'Logout')
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 1,
                              ),
                              Column(
                                children: [
                                  ListTile(
                                    leading: const CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                          "https://i.pravatar.cc/300"),
                                    ),
                                    title: Text(
                                      widget.User,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    subtitle: Text(
                                        '0' + snapshot.data[0]["phoneNumber"],
                                        style: const TextStyle(fontSize: 16)),
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        const Text('MONTHLY SALES',
                                            style: TextStyle(fontSize: 20)),
                                        const Divider(height: 2),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: const [
                                            Text('PHONES',
                                                style: TextStyle(fontSize: 18)),
                                            Text('TOTAL',
                                                style: TextStyle(fontSize: 18))
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              1 /
                                              70,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 25),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(snapshot.data[0]["nphones"],
                                                  style: const TextStyle(
                                                      fontSize: 18)),
                                              Text(snapshot.data[0]["total"],
                                                  style: const TextStyle(
                                                      fontSize: 18))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: containerHeight * 1 / 10,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),

                        // Container(
                        //   height: MediaQuery.of(context).size.height*2/9,
                        //   decoration: const BoxDecoration(
                        //   gradient: LinearGradient(colors: [
                        //   Color.fromRGBO(255, 248, 134,1),
                        //   Color.fromARGB(240, 114, 182,1)
                        // ]),
                        //   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),bottomRight: Radius.circular(50))
                        //   ),
                        //   child: ,
                        // ),
                        Expanded(
                          child: Form(
                            key: formkey,
                            // child: Container(
                            child: ListView(
                              children: [
                                const Center(
                                  child: Text(
                                    'TODAY SALES',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.blue),
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      1 /
                                      70,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: Text(
                                    'Phones Sold:',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GetTextField(
                                    keytype: TextInputType.number,
                                    Controller: phonetec,
                                    hintname: 'Number of Phones Sold',
                                    icon: Icons.mobile_friendly,
                                    isObsecureText: false,
                                    label: 'PHONES'),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: Text(
                                    'Mkopa Phones Sold:',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GetTextField(
                                    keytype: TextInputType.number,
                                    Controller: mphonetec,
                                    hintname: 'Mkopa Phones Sold',
                                    icon: Icons.mobile_friendly,
                                    isObsecureText: false,
                                    label: 'MKOPA PHONES'),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: Text(
                                    'Total Sales:',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GetTextField(
                                    keytype: TextInputType.number,
                                    Controller: salestec,
                                    hintname: 'Total Phones Sales',
                                    icon: Icons.money_sharp,
                                    isObsecureText: false,
                                    label: 'PHONE SALES'),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      1 /
                                      40,
                                ),
                                Center(
                                    child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        //formkey.currentState?.reset();
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        if (formkey.currentState!.validate()) {
                                          //int phones=int.parse(phonetec.text.toString());
                                          int mphones = int.parse(
                                              mphonetec.text.toString());
                                          //int sales=int.parse(salestec.text.toString());

                                          if (mphones >= 1) {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: const Text('MKOPA'),
                                                content: Text(
                                                    'Mkopa Phones Sold $mphones'),
                                                actions: <Widget>[
                                                  Form(
                                                    key: formkeyb,
                                                    child: TextFormField(
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return "Please Enter The Details";
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                      controller: destec,
                                                      decoration: InputDecoration(
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          hintText:
                                                              'Enter Serial',
                                                          labelText:
                                                              'Serial Number'),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      if (formkeyb.currentState!
                                                          .validate()) {
                                                        submitData();
                                                        formkey.currentState!
                                                            .reset();
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        "Sent. Please Wait for backend Processing...")));
                                                        Navigator.pop(
                                                            context, 'OK');
                                                      }
                                                    },
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            submitData();
                                            formkey.currentState!.reset();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Sent. Please Wait for backend Processing...")));
                                          }
                                        }
                                      },
                                      child: const Text('SUBMIT')),
                                )),
                              ],
                            ),
                            //),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // floatingActionButtonLocation:
                  //     FloatingActionButtonLocation.miniCenterDocked,
                  // floatingActionButton: ButtonNavigationBar(
                  //   spaceBetweenItems: 2.0,
                  //   borderRadius: const BorderRadius.all(Radius.circular(20)),
                  //   children: [
                  //     ButtonNavigationItem(
                  //         color: Colors.yellow[700],
                  //         icon: const Icon(Icons.home),
                  //         //label: "Home",
                  //         onPressed: () {}),
                  //     ButtonNavigationItem(
                  //         icon: const Icon(Icons.wallet),
                  //         label: "Mpesa",
                  //         color: Colors.green[400],
                  //         width: MediaQuery.of(context).size.width * 1 / 2,
                  //         onPressed: () {
                  //           Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (BuildContext context) => Mpesa(
                  //                         user: widget.User,
                  //                         Total: snapshot.data[0]["TotalMath"],
                  //                       )));
                  //         }),
                  //     ButtonNavigationItem(
                  //         icon: const Icon(Icons.person_add_alt_rounded),
                  //         //label: "Equity",
                  //         color: Colors.blueAccent,
                  //         onPressed: () {
                  //           Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                 builder: (BuildContext context) => Equity(
                  //                   user: widget.User,
                  //                   Total: snapshot.data[0]["EquityMath"],
                  //                 ),
                  //               ));
                  //         }),
                  //   ],
                  // ),
                  bottomNavigationBar: //Container(
                      //     decoration: const BoxDecoration(
                      //       boxShadow: <BoxShadow>[
                      //         BoxShadow(
                      //           //color: Color.fromRGBO(12, 10, 20, 1),
                      //           blurRadius: 5,
                      //         ),
                      //       ],
                      //     ),
                      //     child:
                      BottomNavigationBar(
                    //backgroundColor: Color.fromRGBO(20, 18, 28, 1),
                    showUnselectedLabels: false,
                    showSelectedLabels: false,
                    iconSize: 30,
                    type: BottomNavigationBarType.fixed,
                    items: [
                      BottomNavigationBarItem(
                          icon: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Sales(User: widget.User)),
                              );
                            },
                            child: Column(children: const [
                              // Image.asset(
                              //   'assets/home.png',
                              //   scale: 30,
                              //   color: Color.fromRGBO(102, 103, 139, 1),
                              // ),
                              Icon(Icons.home),
                              SizedBox(height: .5),
                              Text(
                                "Home",
                                style: TextStyle(
                                    color: Color.fromRGBO(102, 103, 139, 1),
                                    fontSize: 12),
                              )
                            ]),
                          ),
                          label: ""),
                      BottomNavigationBarItem(
                          icon: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Mpesa(
                                            user: widget.User,
                                            Total: snapshot.data[0]
                                                ["TotalMath"],
                                          )),
                                );
                              },
                              child: Column(children: const [
                                Icon(Icons.wallet),
                                Text(
                                  "Mpesa",
                                  style: TextStyle(
                                      color: Color.fromRGBO(102, 103, 139, 1),
                                      fontSize: 12),
                                )
                              ])),
                          label: ""),
                      BottomNavigationBarItem(
                          icon: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Equity(
                                          user: widget.User,
                                          Total: snapshot.data[0]
                                              ["EquityMath"])),
                                );
                              },
                              child: Column(
                                children: const [
                                  // Image.asset(
                                  //   'assets/live-active.png',
                                  //   scale: 30,
                                  //   color: Color.fromRGBO(218, 93, 5, 1),
                                  // ),
                                  Icon(Icons.person_add_alt_rounded),
                                  SizedBox(height: 1),
                                  Text(
                                    "Equity",
                                    style: TextStyle(
                                        color: Color.fromRGBO(218, 93, 5, 1),
                                        fontSize: 12),
                                  )
                                ],
                              )),
                          label: ""),
                    ],
                    //onTap: onTap,
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text(
                "something wrong happened",
                style: TextStyle(color: Colors.red),
              ));
            } else {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Loading......",
                    style: TextStyle(color: Colors.teal, fontSize: 18),
                  )
                ],
              ));
            }
          }),
    );
  }
}

Future<List<dynamic>> getUser(String user) async {
  var url = Uri.parse('https://basemanager.herokuapp.com/getUser.php');
  var response = await http.post(url, body: {"user": user});
  return jsonDecode(response.body);
}

Future _asyncExitConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmExitAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
          backgroundColor: Color.fromRGBO(190, 195, 228, 1),
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Text(
              'Exit Manager',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .03),
            const Text(
              'Are you sure you want to exit the application?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ]),
          content: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, //Center Row contents horizontally,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: const Text(
                  'Exit',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromRGBO(190, 195, 228, 1), fontSize: 10),
                ),
                onPressed: () {
                  Future.delayed(const Duration(milliseconds: 1000), () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  });
                },
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                child: const Text(
                  'Cancel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromRGBO(190, 195, 228, 1), fontSize: 10),
                ),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmExitAction.Cancel);
                },
              ),
            ],
          ));
    },
  );
}

//
enum ConfirmExitAction { Accept, Cancel }
