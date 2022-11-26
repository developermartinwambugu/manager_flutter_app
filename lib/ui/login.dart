import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:manager/model/gettextfield.dart';
import 'package:manager/ui/home.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formkey = GlobalKey<FormState>();

  TextEditingController usertec = TextEditingController();
  TextEditingController passtec = TextEditingController();
  TextEditingController reset = TextEditingController();

  Future<dynamic> getLogin(String user, String password) async {
    var url = Uri.parse('https://basemanager.herokuapp.com/login.php');
    try {
      var response =
          await http.post(url, body: {"user": user, "password": password});

      var data = json.decode(response.body);
      if (data == "success") {
        Fluttertoast.showToast(
            msg: "Logged In Successful",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.cyan,
            fontSize: 16.0);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Sales(
                User: user,
              ),
            ));
        setState(() {
          submitted = !submitted;
        });
        formkey.currentState!.reset();
      } else if (data == "error") {
        setState(() {
          submitted = !submitted;
        });
        Fluttertoast.showToast(
            msg: "Sorry!\nWrong Phone Number/Password. Please try again.",
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.cyan,
            fontSize: 16.0);
      } else {
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
        setState(() {
          submitted = !submitted;
        });
      }
    } catch (IOClientExceptions) {
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
      setState(() {
        submitted = !submitted;
      });
    }
  }

  bool text = true;
  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _asyncExitConfirmDialog(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Builder(builder: (BuildContext context) {
          return OfflineBuilder(
              connectivityBuilder: (BuildContext context,
                  ConnectivityResult connectivity, Widget child) {
                final bool connected = connectivity != ConnectivityResult.none;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    child,
                    Positioned(
                      left: 0.0,
                      right: 0.0,
                      bottom: 0.0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        // color: connected ? null : null,
                        child: connected
                            ? null
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Container(
                                        width: double.infinity,
                                        color:
                                            const Color.fromRGBO(199, 0, 57, 1),
                                        padding: const EdgeInsets.only(
                                            top: 7, bottom: 7),
                                        child: const Text(
                                          "No Internet Connection",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11),
                                        ),
                                      ))
                                ],
                              ),
                      ),
                    ),
                  ],
                );
              },
              child: SingleChildScrollView(
                //physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  color: Colors.grey[200],
                  child: Form(
                    key: formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 1 / 20,
                          child: Container(
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 1 / 30,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "BASE ONE MANAGER",
                            style: TextStyle(
                                fontSize: 21,
                                color: Color.fromARGB(255, 200, 149, 19)),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 1 / 8,
                          child: Image.asset('assets/tron.png'),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 1 / 60,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "WELCOME BACK",
                            style: TextStyle(fontSize: 16, color: Colors.green),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Column(
                          children: [
                            GetTextField(
                              keytype: TextInputType.text,
                              Controller: usertec,
                              hintname: "Enter Your Username",
                              icon: Icons.person,
                              isObsecureText: false,
                              label: "USERNAME",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 1 / 45,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            obscureText: text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter The Details";
                              } else {
                                return null;
                              }
                            },
                            controller: passtec,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      const BorderSide(color: Colors.teal)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    const BorderSide(color: Colors.amber),
                              ),
                              prefixIcon: Icon(Icons.lock),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  text
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  setState(() {
                                    text = !text;
                                  });
                                },
                              ),
                              hintText: "Enter Your Password",
                              labelText: "PASSWORD",
                              fillColor: Colors.grey[300],
                              filled: true,
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        //GetTextField(keytype: TextInputType.text, Controller: passtec, hintname: "Enter Your Password", icon: Icons.lock, isObsecureText: true,label: "PASSWORD"),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 1 / 40,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 1 / 20,
                            width: MediaQuery.of(context).size.width * 2 / 3,
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    submitted = !submitted;
                                  });
                                  if (formkey.currentState!.validate()) {
                                    String user = usertec.text.toString();
                                    String pass = passtec.text.toString();
                                    getLogin(user, pass);
                                  }
                                },
                                child: submitted
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          CircularProgressIndicator(
                                            color: Colors.amber,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("Please wait...")
                                        ],
                                      )
                                    : const Text("LOGIN")),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 1 / 60,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Forgot Password?"),
                            TextButton(
                                onPressed: () {
                                  showModalBottomSheet<void>(
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25.0),
                                        ),
                                      ),
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: Container(
                                            height: 200,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  const Center(
                                                    child: Text(
                                                        'Reset Password?',
                                                        style: TextStyle(
                                                            fontSize: 18)),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  GetTextField(
                                                      keytype:
                                                          TextInputType.text,
                                                      Controller: reset,
                                                      hintname:
                                                          "Enter Your Phone Number",
                                                      icon: Icons.person,
                                                      isObsecureText: false,
                                                      label: 'PHONE'),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      ElevatedButton(
                                                        child: const Text(
                                                            'Cancel'),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                      ),
                                                      ElevatedButton(
                                                        child:
                                                            const Text('Send'),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: const Text("Click here"))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ));
        }),
        resizeToAvoidBottomInset: true,
      ),
    );
  }
}

Future _asyncExitConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmExitAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
          backgroundColor: Colors.cyan, //Color.fromRGBO(190, 195, 228, 1),
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
