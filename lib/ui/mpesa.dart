import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:manager/ui/home.dart';

import '../model/gettextfield.dart';

class Mpesa extends StatefulWidget {
  String user;
  String Total;
  Mpesa({Key? key, required this.user, required this.Total}) : super(key: key);

  @override
  State<Mpesa> createState() => _MpesaState();
}

class _MpesaState extends State<Mpesa> {
  String dat = DateFormat('yyyy-MM-dd KK:mm').format(DateTime.now());

  TextEditingController floattec = TextEditingController();
  TextEditingController cashtec = TextEditingController();
  TextEditingController expensetec = TextEditingController();
  TextEditingController storetec = TextEditingController();
  TextEditingController destec = TextEditingController();

  Future submitData() async {
    var url = Uri.parse('https://basemanager.herokuapp.com/mpesa.php');
    var float = floattec.text.toString();
    var cash = cashtec.text.toString();
    var store = storetec.text.toString();
    var expense = expensetec.text.toString();
    var desc = destec.text.toString();

    var response = await http.post(url, body: {
      "user": widget.user,
      "mFloat": float,
      "mCash": cash,
      "mStore": store,
      "mExpense": expense,
      "description": desc
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
        title: 'Succes',
        desc: 'Todays Data Submitted Successful',
        btnOkOnPress: () {},
        btnOkIcon: Icons.check_circle,
        onDismissCallback: (type) {
          //debugPrint('Dialog Dissmiss from callback $type');
        },
      ).show();
    }
  }

  final formkey = GlobalKey<FormState>();
  final formkeyb = GlobalKey<FormState>();

  final picker = ImagePicker();
  File? imagefile;

  Future<void> pickFile() async {
    var pickedimage = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      imagefile = File(pickedimage!.path);
    });
  }

  Future uploadImage() async {
    final uri =
        Uri.parse("https://mato1mato.000webhostapp.com/baseone/upload.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['name'] = widget.user;
    var pic = await http.MultipartFile.fromPath("image", imagefile!.path);
    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        headerAnimationLoop: false,
        title: 'Success',
        desc: 'Image uploaded successful',
        btnOkOnPress: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Sales(User: widget.user),
              ));
        },
        btnOkIcon: Icons.check_circle,
      ).show();
    } else {
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        headerAnimationLoop: false,
        title: 'Error',
        desc: 'Error Occured.. Please try Again',
        btnOkOnPress: () {},
        btnOkIcon: Icons.info,
        btnOkColor: Colors.orange,
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.green, Colors.greenAccent])),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 1 / 18),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            'MPESA',
                            style: TextStyle(fontSize: 22),
                          ),
                          Text(dat),
                          IconButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Sales(User: widget.user),
                                  ));
                            },
                            icon: const Icon(Icons.arrow_back),
                            tooltip: 'HOME',
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      child: Form(
                          key: formkey,
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'MPESA FLOAT:',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 1 / 77,
                              ),
                              GetTextField(
                                  keytype: TextInputType.number,
                                  Controller: floattec,
                                  hintname: 'Mpesa Float',
                                  icon: Icons.account_balance,
                                  isObsecureText: false,
                                  label: 'FLOAT'),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 1 / 40,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'MPESA CASH:',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 1 / 77,
                              ),
                              GetTextField(
                                  keytype: TextInputType.number,
                                  Controller: cashtec,
                                  hintname: 'Mpesa Cash',
                                  icon: Icons.account_balance,
                                  isObsecureText: false,
                                  label: 'CASH'),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 1 / 40,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'MPESA STORE:',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 1 / 77,
                              ),
                              GetTextField(
                                  keytype: TextInputType.number,
                                  Controller: storetec,
                                  hintname: 'Mpesa Store',
                                  icon: Icons.account_balance,
                                  isObsecureText: false,
                                  label: 'STORE'),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 1 / 40,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'MPESA EXPENSE:',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 1 / 77,
                              ),
                              GetTextField(
                                  keytype: TextInputType.number,
                                  Controller: expensetec,
                                  hintname: 'Mpesa Expenses',
                                  icon: Icons.account_balance,
                                  isObsecureText: false,
                                  label: 'MPESA EXPENSE'),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 1 / 40,
                              ),
                              Center(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        if (formkey.currentState!.validate()) {
                                          int float = int.parse(
                                              floattec.text.toString());
                                          int cash = int.parse(
                                              cashtec.text.toString());
                                          int store = int.parse(
                                              storetec.text.toString());
                                          int expense = int.parse(
                                              expensetec.text.toString());
                                          int total = int.parse(widget.Total);

                                          int totalInm =
                                              (float + expense + store + cash);
                                          formkey.currentState!.reset();

                                          if (total == totalInm) {
                                            submitData();

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Sent. Please Wait for backend Processing...")));
                                          } else if (totalInm > total) {
                                            int excess = totalInm - total;

                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: const Text('MPESA'),
                                                content: Text(
                                                    'Excess of: $excess Kshs'),
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
                                                              'Enter Description',
                                                          labelText:
                                                              'Description'),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      if (formkeyb.currentState!
                                                          .validate()) {
                                                        submitData();
                                                        Navigator.pop(context);

                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        "Sent. Please Wait for backend Processing...")));
                                                      }
                                                    },
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else if (totalInm < total) {
                                            int less = (total - totalInm);

                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: const Text('MPESA'),
                                                content:
                                                    Text('Less of: $less Kshs'),
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
                                                              'Enter Description',
                                                          labelText:
                                                              'Description'),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      if (formkeyb.currentState!
                                                          .validate()) {
                                                        submitData();
                                                        Navigator.pop(context);

                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        "Sent. Please Wait for backend Processing...")));
                                                      }
                                                    },
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: 'Error');
                                          }
                                        }
                                      },
                                      child: const Text('SEND'))),
                              const SizedBox(
                                height: 5,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Card(
                                  margin: const EdgeInsets.all(10),
                                  child: GestureDetector(
                                    onTap: (() {
                                      const Tooltip(
                                        message: "Press the upload button",
                                      );
                                    }),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.all(20),
                                            child: imagefile == null
                                                ? const Center(
                                                    child: Text(
                                                      "Please select an image",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  )
                                                : Image.file(imagefile!)),
                                        OutlinedButton(
                                            onPressed: () {
                                              if (imagefile != null) {
                                                uploadImage();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Sent. Please Wait for backend Processing...")));
                                              } else {
                                                showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    title: const Text('IMAGE'),
                                                    content: const Text(
                                                        'Please select image'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                          onPressed: () {
                                                            
                                                            pickFile();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              const Text("Ok")),
                                                    ],
                                                  ),
                                                );
                                              }
                                            },
                                            child: const Text("Upload"))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            pickFile();
          },
          tooltip: 'Select Image',
          child: const Icon(Icons.add)),
    );
  }
}
