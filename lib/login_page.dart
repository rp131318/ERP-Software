import 'dart:convert';
import 'package:erp_software/Widgets/button_widget.dart';
import 'package:erp_software/Widgets/progressHud.dart';
import 'package:erp_software/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'globalVariable.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final idController = TextEditingController();
  final passController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe6e6e6),
      body: ProgressHUD(
        isLoading: isLoading,
        child: Center(
          child: Card(
            // color: colorDark,
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 33,
                  ),
                  SizedBox(
                    child: titleTextField("ID", idController),
                    width: 333,
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  SizedBox(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18),
                            child: Text(
                              "Password",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: colorBlack5,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          height: 26,
                          decoration: BoxDecoration(
                              color: Color(0xfff0f0f0),
                              // border: Border.all(width: 1, color: grey),
                              borderRadius: BorderRadius.circular(0)),
                          margin: EdgeInsets.only(left: 18, right: 18, top: 6),
                          padding: EdgeInsets.only(left: 14),
                          child: TextFormField(
                            style: TextStyle(fontSize: 14),
                            controller: passController,
                            cursorColor: Colors.black45,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            onFieldSubmitted: (value) {
                              setState(() {
                                isLoading = true;
                              });
                              Uri url = Uri.parse(APIUrl.mainUrl +
                                  APIUrl.login +
                                  "?name=${idController.text}&password=${passController.text}");
                              get(url).then((value) {
                                //
                                print("Res Login :: ${jsonDecode(value.body)}");
                                if (jsonDecode(value.body)[0]["login"]
                                        .toString() ==
                                    "success") {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if (jsonDecode(value.body)[0]["type"]
                                          .toString() ==
                                      "all") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage(0)),
                                    );
                                  } else if (jsonDecode(value.body)[0]["type"]
                                          .toString() ==
                                      "crm") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage(1)),
                                    );
                                  } else if (jsonDecode(value.body)[0]["type"]
                                          .toString() ==
                                      "sales") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage(2)),
                                    );
                                  } else if (jsonDecode(value.body)[0]["type"]
                                          .toString() ==
                                      "stock") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage(3)),
                                    );
                                  }
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  showSnackbar(context, "Invalid Credential",
                                      Colors.red);
                                }
                              });
                            },
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: " ",
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ],
                    ),
                    width: 333,
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  ButtonWidget(
                    context: context,
                    buttonText: "Login",
                    function: () {
                      setState(() {
                        isLoading = true;
                      });
                      Uri url = Uri.parse(APIUrl.mainUrl +
                          APIUrl.login +
                          "?name=${idController.text}&password=${passController.text}");
                      get(url).then((value) {
                        //
                        print("Res Login :: ${jsonDecode(value.body)}");
                        if (jsonDecode(value.body)[0]["login"].toString() ==
                            "success") {
                          setState(() {
                            isLoading = false;
                          });
                          if (jsonDecode(value.body)[0]["type"].toString() ==
                              "all") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(0)),
                            );
                          } else if (jsonDecode(value.body)[0]["type"]
                                  .toString() ==
                              "crm") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(1)),
                            );
                          } else if (jsonDecode(value.body)[0]["type"]
                                  .toString() ==
                              "sales") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(2)),
                            );
                          } else if (jsonDecode(value.body)[0]["type"]
                                  .toString() ==
                              "stock") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(3)),
                            );
                          }
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          showSnackbar(
                              context, "Invalid Credential", Colors.red);
                        }
                      });
                    },
                    height: 28,
                    isIcon: false,
                    width: 300,
                    widget: Container(),
                    right: 0,
                    left: 0,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
