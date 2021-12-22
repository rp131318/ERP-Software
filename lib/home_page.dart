import 'package:erp_software/Tab%20Pages/attendence_page.dart';
import 'package:erp_software/Tab%20Pages/custumer_details_page.dart';
import 'package:erp_software/Tab%20Pages/finish_product_page.dart';
import 'package:erp_software/Tab%20Pages/generate_bill_page.dart';
import 'package:erp_software/Tab%20Pages/raw_material_page.dart';
import 'package:erp_software/Tab%20Pages/sales_details_page.dart';
import 'package:erp_software/Tab%20Pages/sell_purchase_page.dart';
import 'package:erp_software/Tab%20Pages/tab_home_page.dart';
import 'package:erp_software/globalVariable.dart';
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

  _HomePageState(this.adminCount);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              child: ListView.builder(
                  itemCount: buttonArray.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        if (adminCount == 2) {
                          if (index + 1 == 4 || index + 1 == 9) {
                            //true
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
                        } else if (adminCount == 3) {
                          if (index + 1 == 1 || index + 1 == 2) {
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
                        } else if (adminCount == 1) {
                          if (index + 1 == 6 || index + 1 == 7) {
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
