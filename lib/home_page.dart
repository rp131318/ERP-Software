import 'package:erp_software/Tab%20Pages/attendence_page.dart';
import 'package:erp_software/Tab%20Pages/custumer_details_page.dart';
import 'package:erp_software/Tab%20Pages/finish_product_page.dart';
import 'package:erp_software/Tab%20Pages/generate_bill_page.dart';
import 'package:erp_software/Tab%20Pages/raw_material_page.dart';
import 'package:erp_software/Tab%20Pages/sales_details_page.dart';
import 'package:erp_software/Tab%20Pages/sell_purchase_page.dart';
import 'package:erp_software/Tab%20Pages/tab_home_page.dart';
import 'package:erp_software/globalVariable.dart';
import 'package:erp_software/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filepicker_windows/filepicker_windows.dart';

import 'Tab Pages/emplyoee_details_page.dart';
import 'Tab Pages/marketing_details.dart';

class HomePage extends StatefulWidget {
  int adminCount;

  HomePage(this.adminCount);

  @override
  _HomePageState createState() => _HomePageState(adminCount);
}

class _HomePageState extends State<HomePage> {
  int adminCount;
  int currentPage = 0;
  var buttonArray = [
    "Raw Material",
    "Finish Product",
    "Generate Bill",
    "Customers",
    "Sales Details",
    "Employee Details",
    "Employee Attn.",
    "Sell & Purchase",
    "Marketing Details",
  ];
  String loginType = " ";

  _HomePageState(this.adminCount);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (adminCount == 0) {
      loginType = "Breathe";
    } else if (adminCount == 1) {
      loginType = "CRM";
    } else if (adminCount == 2) {
      loginType = "Sales";
    } else if (adminCount == 3) {
      loginType = "Stocks";
    }
  }

  /*
  * all -> 0
  * crm -> 1
  * sales -> 2
  * stock -> 3
  * */

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
              child: Column(
                children: [
                  SizedBox(
                    height: 22,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        loginType,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: Icon(
                          Icons.logout,
                          size: 33,
                        ),
                      )
                    ],
                  ),
                  ListView.builder(
                      itemCount: buttonArray.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            //Sales
                            if (adminCount == 2) {
                              if (index + 1 == 4 ||
                                  index + 1 == 2 ||
                                  index + 1 == 5 ||
                                  index + 1 == 8) {
                                //true
                                userAccess = "sales";
                                // loginType = "Sales";
                                setState(() {
                                  currentPage = index + 1;
                                });
                              } else {
                                showSnackbar(
                                    context,
                                    "You don't has permission to access this feature",
                                    Colors.red,
                                    1000);
                              }
                              //Stock
                            } else if (adminCount == 3) {
                              if (index + 1 == 1 ||
                                  index + 1 == 2 ||
                                  index + 1 == 8) {
                                userAccess = "stock";
                                // loginType = "Stocks";
                                setState(() {
                                  currentPage = index + 1;
                                });
                              } else {
                                showSnackbar(
                                    context,
                                    "You don't has permission to access this feature",
                                    Colors.red,
                                    1000);
                              }
                              //CRM
                            } else if (adminCount == 1) {
                              if (index + 1 == 6 ||
                                  index + 1 == 7 ||
                                  index + 1 == 3 ||
                                  index + 1 == 4 ||
                                  index + 1 == 9) {
                                userAccess = "-";
                                // loginType = "CRM";
                                setState(() {
                                  currentPage = index + 1;
                                });
                              } else {
                                showSnackbar(
                                    context,
                                    "You don't has permission to access this feature",
                                    Colors.red,
                                    1000);
                              }
                            } else {
                              userAccess = "-";
                              // loginType = "Breathe";
                              setState(() {
                                currentPage = index + 1;
                              });
                            }
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
                ],
              ),
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
      case 7:
        return AttendancePage();
        break;
      case 8:
        return SellPurchasePage();
        break;
      case 9:
        return MarketingDetails();
        break;
    }
    return TabHomePage();
  }
}
