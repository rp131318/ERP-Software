import 'package:dustbin/Tab%20Pages/custumer_details_page.dart';
import 'package:dustbin/Tab%20Pages/finish_product_page.dart';
import 'package:dustbin/Tab%20Pages/generate_bill_page.dart';
import 'package:dustbin/Tab%20Pages/raw_material_page.dart';
import 'package:dustbin/Tab%20Pages/sales_details_page.dart';
import 'package:dustbin/Tab%20Pages/tab_home_page.dart';
import 'package:dustbin/globalVariable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filepicker_windows/filepicker_windows.dart';

import 'Tab Pages/emplyoee_details_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  var buttonArray = [
    "Raw Material",
    "Finish Product",
    "Generate Bill",
    "Customers",
    "Sales Details",
    "Employee Details"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Init");
    // final file = OpenFilePicker()
    //   ..filterSpecification = {
    //     'Word Document (*.doc)': '*.doc',
    //     'Web Page (*.htm; *.html)': '*.htm;*.html',
    //     'Text Document (*.txt)': '*.txt',
    //     'All Files': '*.*'
    //   }
    //   ..defaultFilterIndex = 0
    //   ..defaultExtension = 'doc'
    //   ..title = 'Select a document';
    //
    // final result = file.getFile();
    // if (result != null) {
    //   print(result.path);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: colorDark,
              width: double.infinity,
              margin: EdgeInsets.zero,
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          currentPage = index + 1;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            top: index == 0 ? 111 : 11,
                            right: currentPage == index + 1 ? 0 : 22,
                            left: 22),
                        height: 38,
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${buttonArray[index]}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20,
                                color: colorBlack5,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        color: currentPage == index + 1
                            ? Color(0xfffafafa)
                            : colorUnSelected,
                      ),
                    );
                  }),
            ),
          ),
          Expanded(flex: 8, child: getPage(currentPage)),
        ],
      ),
    );
  }

  getPage(int currentPage) {
    print(currentPage);
    switch (currentPage) {
      case 1:
        return RawMaterialPage();
        break;
      case 2:
        return FinishProductPage();
        break;
      case 3:
        return GenerateBillPage();
        break;
      case 4:
        return CustumerDetailsPage();
        break;
      case 5:
        return SalesDetailsPage();
        break;
      case 6:
        return EmplyoeeDetailsPage();
        break;
    }
    return TabHomePage();
  }
}
