import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../model/gettextfield.dart';
import 'home.dart';

class Equity extends StatefulWidget {
  String user;
  String Total;
  Equity({Key? key, required this.user, required this.Total}) : super(key: key);

  @override
  State<Equity> createState() => _EquityState();
}

class _EquityState extends State<Equity> {
  String dat = DateFormat('yyyy-MM-dd KK:mm').format(DateTime.now());

  TextEditingController ecashtec = TextEditingController();
  TextEditingController efloattec = TextEditingController();
  TextEditingController cooptec = TextEditingController();
  TextEditingController destec = TextEditingController();

  Future submitData() async {
    var url = Uri.parse('https://basemanager.herokuapp.com/equity.php');

    var float = efloattec.text.toString();
    var cash = ecashtec.text.toString();
    var kcb = cooptec.text.toString();
    var description = destec.text.toString();

    var response = await http.post(url, body: {
      "user": widget.user,
      "float": float,
      "cash": cash,
      "kcb": kcb,
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
        title: 'success',
        desc: 'Todays Data Submitted Successful',
        btnOkOnPress: () {},
        btnOkIcon: Icons.check_circle,
        onDismissCallback: (type) {
          debugPrint('Dialog Dissmiss from callback $type');
        },
      ).show();
    }
  }

  File? imagefile;
  final picker = ImagePicker();

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
    //heroku url https://basemanager.herokuapp.com/upload.php

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

  final formkey = GlobalKey<FormState>();
  final formkeyb = GlobalKey<FormState>();

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
                        colors: [Colors.blue, Colors.blueAccent])),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 1 / 18,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            'EQUITY',
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
                                  'EQUITY FLOAT:',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      1 /
                                      66),
                              GetTextField(
                                  keytype: TextInputType.number,
                                  Controller: efloattec,
                                  hintname: 'Equity Float',
                                  icon: Icons.account_balance,
                                  isObsecureText: false,
                                  label: 'FLOAT'),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 1 / 33,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'EQUITY CASH:',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 1 / 66,
                              ),
                              GetTextField(
                                  keytype: TextInputType.number,
                                  Controller: ecashtec,
                                  hintname: 'Equity Cash',
                                  icon: Icons.account_balance,
                                  isObsecureText: false,
                                  label: 'CASH'),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 1 / 33,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'KCB AND COOP FLOAT:',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 1 / 66,
                              ),
                              GetTextField(
                                  keytype: TextInputType.number,
                                  Controller: cooptec,
                                  hintname: 'Kcb/Coop Float',
                                  icon: Icons.account_balance,
                                  isObsecureText: false,
                                  label: 'KCB/COOP FLOAT'),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 1 / 33,
                              ),
                              Center(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        if (formkey.currentState!.validate()) {
                                          int cash = int.parse(
                                              ecashtec.text.toString());
                                          int float = int.parse(
                                              efloattec.text.toString());
                                          int coop = int.parse(
                                              cooptec.text.toString());
                                          int totalIn = (cash + float + coop);
                                          int total = int.parse(widget.Total);
                                          formkey.currentState!.reset();
                                          if (total == totalIn) {
                                            submitData();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Sent. Please Wait for backend Processing...")));
                                          } else if (totalIn > total) {
                                            int excess = (totalIn - total);

                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: const Text('EQUITY'),
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
                                          } else if (totalIn < total) {
                                            int less = (total - totalIn);

                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: const Text('EQUITY'),
                                                content:
                                                    Text('Less of: $less Kshs'),
                                                actions: <Widget>[
                                                  Form(
                                                    key: formkeyb,
                                                    child: TextFormField(
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
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return "Please Enter The Details";
                                                          } else {
                                                            return null;
                                                          }
                                                        }),
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
                              const SizedBox(height: 20),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Card(
                                  margin: const EdgeInsets.all(10),
                                  child: GestureDetector(
                                    onTap: (() {
                                      uploadImage;
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
                                                  ))
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
