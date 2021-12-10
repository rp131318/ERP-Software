library my_prj.globals;

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String surveyNumberText = "-";
String nameText = "-";
String emailText = "-";
String phoneText = "-";
String userReferralCode = "-";
String referralCode = "-";
String userUid = "-";
String points = "0";
String cityText = "India";

String hectare = "Hectare";
String acre = "Acre";
String bigha = "Bigha";
String degreeCenti = "°C";

int getIndexFromArray(List finalTitle, String s) {
  for (int i = 0; i < finalTitle.length; i++) {
    if (finalTitle[i] == s) {
      return i;
    }
  }
}

const Color colorAccent = Color(0xFF93C572);
// const Color colorAccent = Color(0xff2d6aff);
const Color colorCard = Color(0xfff3f3f3);
const Color colorDark = Color(0xffECBF1F);
// const Color colorDark = Color(0xFF003cc1);
const Color colorCardWhite = Color(0xFFf3f3f3);
const Color colorCardLight = Color(0xffeff4ff);
// const Color colorCard = Color(0xfff3f3f3);
const Color colorBlack5 = Color(0xFF404145);
// const Color colorBlack5 = Color(0xFFC1C1C1);
// const Color colorGreen = Color(0xFF009000);
const Color colorDisable = Color(0xffdbd9db);
const Color colorUnSelected = Color(0xffF5F5F5);
const Color colorButton = Color(0xff505050);
// const Color colorGreenAccent = Color(0xFF7cc242);
final grey = Colors.grey;
final rsSign = " \u{20B9} ";
final tempC = " \u2103";
final flutterLongText = "Miusov, as a man man of breeding and deilcacy, could "
    "not but feel some inwrd qualms, when he reached the Father Superior's with "
    "Ivan: he felt ashamed of havin lost his temper. He felt that he ought to "
    "have disdaimed that despicable wretch, Fyodor Pavlovitch, too much to have "
    "been upset by him in Father Zossima's cell, and so to have "
    "forgotten himself.";
final flutterShortText = "Note that UltimateSpell displays the text in the "
    "dialog box sentence-by-sentence just like Microsoft Word.";

void showSnackbar(context, String message, MaterialColor color,
    [int duration = 4000]) {
  final snackBar = SnackBar(
    backgroundColor: color,
    duration: Duration(milliseconds: duration),
    content: Text(message),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Widget buildTitle(String text) {
  return Align(
    alignment: Alignment.topLeft,
    child: Padding(
      padding: const EdgeInsets.only(left: 14, top: 28, right: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
                fontSize: 18, color: colorBlack5, fontWeight: FontWeight.bold),
          ),
          Divider(
            thickness: 2,
            color: colorBlack5,
          ),
        ],
      ),
    ),
  );
}

// void nextPage(context, Widget page) {
//   Navigator.push(context,
//       PageTransition(type: PageTransitionType.rightToLeft, child: page));
// }

class APIUrl {
  static String mainUrl =
      "https://breathemedicalsystems.com/inventory_management/";

  // http://breathemedicalsystems.com/inventory_management/get_rawdetails.php

  //Raw material get and post
  static String uploadRaw = "upload_rawMaterials.php";
  static String getRaw = "get_rawMaterial.php";

  //raw material used in final product get and post
  static String uploadFinishLinkRaw = "upload_raw_details.php";
  static String getFinishLinkRaw = "get_rawdetails.php";

  //final product get and post
  static String uploadFinalProduct = "upload_final_product.php";

  //get details of raw material used in the particular product
  static String rawMaterialUsed = "get_details_final.php";

  //get details of available quantity in that raw material
  static String availableRaw = "get_availableraw.php";

  //update the subtracted quantity in that raw material
  static String updateQuantityRaw = "update_availbleraw.php";

  //upload the finial product
  static String finalProductUpload = "upload_final_product.php";

  //get the final products
  static String getFinalProduct = "get_final_product.php";

  //get and upload final pakka bill
  static String postPakkaBill = "upload_pakkabill.php";
  static String getPakkaBill = "get_pakkabill.php";

  //get and upload kaccha bill
  static String postKacchaBill = "upload_kacchabill.php";
  static String getKacchaBill = "get_kacchabill.php";

  //get and upload customer detaiks
  static String postCustomer = "upload_customer.php";
  static String getCustomer = "get_customer.php";

  //get and upload customer details
  static String postEmployee = "upload_employee.php";
  static String getEmployee = "get_employee.php";

  //get avalailable out
  static String getAvalailablOut = "get_availableOut.php";
  static String updateOut = "update_out.php";
  static String postAttendance = "attendence_post.php";
  static String getAttendance = "attendence_get.php";
  static String updateAttendance = "attendence_update.php";
}

Future<String> createOrderMessage() async {
  var order = await fetchUserOrder();
  return 'Your order is: $order';
}

Widget loadingWidget([String msg = "No details were found."]) {
  return Center(
    child: FutureBuilder(
        future: Future.delayed(Duration(seconds: 3)),
        builder: (c, s) => s.connectionState == ConnectionState.done
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.hourglass_empty_rounded,
                    size: 44,
                    color: colorBlack5,
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Text(
                    msg,
                    style: TextStyle(fontSize: 18),
                  )
                ],
              )
            : CircularProgressIndicator()),
  );
}

Future<String> fetchUserOrder() => Future.delayed(
      const Duration(seconds: 2),
      () => 'Large Latte',
    );

String flutterMapValue(outputStart, outputEnd, inputStart, inputEnd, input) {
  String output = (outputStart +
          ((outputEnd - outputStart) / (inputEnd - inputStart)) *
              (input - inputStart))
      .toString();
  print("Loading Return :: $output");
  return output;
}

generateReferralCode() {}

// Color getRandomColor() {
//   var colorData = [
//     Colors.cyan.shade300,
//     Colors.deepOrange.shade300,
//     Colors.green.shade300,
//     Colors.purple.shade300,
//     Colors.deepPurple.shade300,
//     Colors.brown.shade300,
//     Colors.teal.shade300,
//   ];
//   var rng = new Random();
//   return colorData[rng.nextInt(colorData.length)];
// }

bool validateField(context, TextEditingController controller,
    [int validateLength = 0, String fieldType = "default"]) {
  if (controller.text.length > validateLength) {
    switch (fieldType) {
      case "default":
        return true;
        break;
      case "phone":
        if (controller.text.length == 10) {
          return true;
        }
        showSnackbar(context, "Phone number should be 10 digits", Colors.red);

        break;
      case "email":
        if (controller.text.contains(RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
          return true;
        }
        showSnackbar(context, "Provide correct email address", Colors.red);
        break;
      case "password":
        if (controller.text.length > 8) {
          return true;
        }
        showSnackbar(context, "Password should be 8 digits", Colors.red);
        break;
    }
  } else {
    showSnackbar(context, "Field Can't be empty...", Colors.red);
    return false;
  }
}

Widget titleTextField(String s, TextEditingController nameController,
    [bool enable = true, final keyBoard = TextInputType.text]) {
  return Column(
    children: [
      Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Text(
            s,
            style: TextStyle(
                fontSize: 14, color: colorBlack5, fontWeight: FontWeight.bold),
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
          enabled: enable,
          style: TextStyle(fontSize: 14),
          controller: nameController,
          keyboardType: keyBoard,
          cursorColor: Colors.black45,
          // textAlign: TextAlign.center,
          decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: " ",
              hintStyle: TextStyle(color: Colors.grey)),
        ),
      ),
    ],
  );
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
const _chars1 = '1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

String getRandomInt(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars1.codeUnitAt(_rnd.nextInt(_chars1.length))));

class Config {
  static String baseUrl = "http://192.168.4.1/";
  static String productName = "product_name";
  static String steps = "steps";
  static String sensorData = "sensor";
  static String whichSensor = "which_sensor";
  static String loadingVar = "connectSensor";
}

class StatusColor {
  static const Color lowBg = Color(0xFFFDE3E3);
  static const Color highBg = Color(0xFFE6E7FF);
  static const Color mediumBg = Color(0xFFE4FFE4);
  static const Color lowText = Color(0xffff0000);
  static const Color mediumText = Color(0xff03e003);
  static const Color highText = Color(0xff0202de);
  static const Color lowGrad = Color(0xffbd0303);
  static const Color mediumGrad = Color(0xff04a504);
  static const Color highGrad = Color(0xff02028e);
}

Future<bool> checkInternet() async {
  try {
    final result = await InternetAddress.lookup('www.google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      return Future.value(true);
    }
  } on SocketException catch (_) {
    print('not connected');
    return Future.value(false);
  }
  return Future.value(false);
}

class ProjectDetails {
  String cropName;
  String climate;
  String irrigationType;
  String pdfLink;
  String projectName;
  String pendingReading;
  String soilType;
  String unit;
  String farmArea;
  String district;
  String seedType;
  String surveyNo;
  String yield;
  String report;
  String season;
  String variType;
  String date;
  String totalReading;

  // int age;

  ProjectDetails(
      this.cropName,
      this.climate,
      this.irrigationType,
      this.pdfLink,
      this.projectName,
      this.pendingReading,
      this.soilType,
      this.unit,
      this.farmArea,
      this.district,
      this.seedType,
      this.surveyNo,
      this.yield,
      this.report,
      this.season,
      this.variType,
      this.date,
      this.totalReading);

  factory ProjectDetails.fromJson(dynamic json) {
    return ProjectDetails(
      json['climate'] as String,
      json['crop_name'] as String,
      json['district'] as String,
      json['farm_area'] as String,
      json['irrigation_type'] as String,
      json['organic_carbon'] as String,
      json['pending_reading'] as String,
      json['project_name'] as String,
      json['season'] as String,
      json['seed_type'] as String,
      json['soil_type'] as String,
      json['survey_no'] as String,
      json['total_reading'] as String,
      json['variety_seed_type'] as String,
      json['sowing_date'] as String,
      json['report'] as String,
      json['crop_name'] as String,
      json['crop_name'] as String,
    );
  }

// @override
// String toString() {
//   return '{ ${this.name}, ${this.age} }';
// }
}

Future<void> copyToClipboard(context, copyText) async {
  await Clipboard.setData(ClipboardData(text: copyText));
  showSnackbar(context, '$copyText Copied to clipboard', Colors.green);
}

int getJsonLength(jsonText) {
  int len = 0;
  try {
    while (jsonText[len] != null) {
      len++;
    }
    // print("Len :: $len");
  } catch (e) {
    // print("Len Catch :: $len");
    return len;
  }
}

String stringToJson(String key, String value) {
  String dff = ("\"" + key + "\"\r" + ": \"" + value + "\"\r").toString();
  String jsonText = '"$key": "$value"';
  print("Dff :: $jsonText");
  return jsonText;
}

//.................Project Details..............//
String globalArea = "0";
String globalAreaUnit = "0";
String globalYield = "0";
//..............................................//

class Data {
  String projectName;
  String surveyNo;
  String district;
  String farmerName;
  String cropName;
  String climateZone;
  String soilType;
  String season;
  String seedType;
  String varietySoilType;
  String farmArea;
  String farmAreaUnit;
  String sowingDate;
  String organicCarbon;
  String irrigationType;
  String creationDate;

  Data({
    this.projectName,
    this.surveyNo,
    this.district,
    this.irrigationType,
    this.farmerName,
    this.cropName,
    this.climateZone,
    this.soilType,
    this.season,
    this.seedType,
    this.varietySoilType,
    this.farmArea,
    this.farmAreaUnit,
    this.sowingDate,
    this.organicCarbon,
    this.creationDate,
  });
}
