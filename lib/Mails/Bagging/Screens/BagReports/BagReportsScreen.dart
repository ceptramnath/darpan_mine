import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
import 'package:darpan_mine/Widgets/DottedLine.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class BagReportsScreen extends StatefulWidget {
  const BagReportsScreen({Key? key}) : super(key: key);

  @override
  _BagReportsScreenState createState() => _BagReportsScreenState();
}

class _BagReportsScreenState extends State<BagReportsScreen> {
  String? selectedType;

  final dateFocus = FocusNode();

  final formGlobalKey = GlobalKey<FormState>();

  final dateController = TextEditingController();

  List<String> bagTypes = ["Bag Open", "Bag Close"];

  List bagNumber = [];
  List bagTime = [];
  List bagArticles = [];
  List bagArticleTypes = [];
  List bagInventoryName = [];
  List bagInventoryQuantity = [];
  List bagInventoryPrice = [];
  List bagDocuments = [];
  List bagCash = [];

  clearAll() {
    bagNumber.clear();
    bagArticles.clear();
    bagArticleTypes.clear();
    bagInventoryPrice.clear();
    bagInventoryName.clear();
    bagInventoryQuantity.clear();
    bagDocuments.clear();
    bagCash.clear();
  }

  getReports() async {
    await clearAll();
    if (dateController.text.isNotEmpty && selectedType!.isNotEmpty) {
      //Bag Open Report Data Fetching
      if (selectedType == "Bag Open") {
        final bagDetails = await BagTable()
            .select()
            .startBlock
            .BagDate
            .equals(dateController.text)
            .and
            .BagType
            .equals('Open')
            .endBlock
            .toMapList();
        print('Bag Open Count- Report ');
        print(bagDetails.length);

        for (int i = 0; i < bagDetails.length; i++) {
          print(bagDetails[i].toString());
        }
        if (bagDetails.isNotEmpty) {
          for (int i = 0; i < bagDetails.length; i++) {
            bagNumber.add(bagDetails[i]['BagNumber']);
            bagTime.add(bagDetails[i]['BagTime']);

            // Articles
            final articlesBag = await BagArticlesTable()
                .select()
                .BagNumber
                .equals(bagDetails[i]['BagNumber'])
                .and
                .Status
                .equals('Added')
                .toMapList();

            print("Adding Articles to Bag Open Report..!");
            print(articlesBag.length);

            if (articlesBag.isNotEmpty) {
              List articlesInBag = [];
              List articleTypesInBag = [];
              for (int i = 0; i < articlesBag.length; i++) {
                print(articlesBag[i]['ArticleNumber']);
                articlesInBag.add(articlesBag[i]['ArticleNumber']);
                articleTypesInBag.add(articlesBag[i]['ArticleType']);
              }
              bagArticles.add(articlesInBag);
              bagArticleTypes.add(articleTypesInBag);
            }

            // Inventory
            final inventoryBag = await BagStampsTable()
                .select()
                .BagNumber
                .equals(bagDetails[i]['BagNumber'])
                .toMapList();
            if (inventoryBag.isNotEmpty) {
              List inventoryNameInBag = [];
              List inventoryQuantityInBag = [];
              List inventoryPriceInBag = [];
              for (int i = 0; i < inventoryBag.length; i++) {
                inventoryNameInBag.add(inventoryBag[i]['StampName']);
                inventoryQuantityInBag.add(inventoryBag[i]['StampQuantity']);
                inventoryPriceInBag.add(inventoryBag[i]['StampPrice']);
              }
              bagInventoryName.add(inventoryNameInBag);
              bagInventoryQuantity.add(inventoryQuantityInBag);
              bagInventoryPrice.add(inventoryPriceInBag);
            }

            // Documents
            final documentsBag = await BagDocumentsTable()
                .select()
                .BagNumber
                .equals(bagDetails[i]['BagNumber'])
                .toMapList();
            if (documentsBag.isNotEmpty) {
              List documentsInBag = [];
              for (int i = 0; i < documentsBag.length; i++) {
                documentsInBag.add(documentsBag[i]['DocumentName']);
              }
              bagDocuments.add(documentsInBag);
            }

            // Cash
            final cashBag = await BagCashTable()
                .select()
                .BagNumber
                .equals(bagDetails[i]['BagNumber'])
                .toMapList();

            print(cashBag.length);
            print('cashBag');
            for (int i = 0; i < bagCash.length; i++) {
              print(cashBag[i]['CashAmount'].toString());
            }
            if (cashBag.isNotEmpty) {
              List cashInBag = [];
              for (int i = 0; i < cashBag.length; i++) {
                cashInBag.add(cashBag[i]['CashAmount']);
              }
              bagCash.add(cashInBag);
              print(bagCash.length);
              for (int i = 0; i < bagCash.length; i++) {
                print(bagCash[i]);
              }
            }
          }
          return bagNumber;
        } else {
          return null;
        }
      }
      //Bag Close Report Data Fetching
      else if (selectedType == "Bag Close") {
        final bagDetails = await BagCloseTable()
            .select()
            .ClosedDate
            .equals(dateController.text)
            .toMapList();
        print(bagDetails);
        if (bagDetails.isNotEmpty) {
          for (int i = 0; i < bagDetails.length; i++) {
            bagNumber.add(bagDetails[i]['BagNumber']);
            bagTime.add(bagDetails[i]['ClosedTime']);

            // Articles
            final articlesBag = await BagArticlesTable()
                .select()
                .BagNumber
                .equals(bagDetails[i]['BagNumber'])
                .and
                .Status
                .equals('Closed')
                .toMapList();
            if (articlesBag.isNotEmpty) {
              List articlesInBag = [];
              List articleTypesInBag = [];
              for (int i = 0; i < articlesBag.length; i++) {
                articlesInBag.add(articlesBag[i]['ArticleNumber']);
                articleTypesInBag.add(articlesBag[i]['ArticleType']);
              }
              bagArticles.add(articlesInBag);
              bagArticleTypes.add(articleTypesInBag);
            }
          }

          return bagDetails;
        } else {
          return null;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Bagging Reports',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22),
        ),
        backgroundColor: const Color(0xFFB71C1C),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true),
                          isExpanded: true,
                          iconEnabledColor: Colors.blueGrey,
                          hint: const Text(
                            'Report Type',
                            style: TextStyle(color: Color(0xFFCFB53B)),
                          ),
                          items: bagTypes.map((String myMenuItem) {
                            return DropdownMenuItem<String>(
                              value: myMenuItem,
                              child: Text(
                                myMenuItem,
                                style: const TextStyle(color: Colors.blueGrey),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? valueSelectedByUser) {
                            setState(() {
                              selectedType = valueSelectedByUser!;
                            });
                          },
                          value: selectedType,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: YearForm(
                        title: 'Date',
                        selectYear: () {
                          _selectDate(context);
                        },
                        controller: dateController,
                        focusNode: dateFocus),
                  ),
                ],
              ),
              FutureBuilder(
                  future: getReports(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Icon(
                            Icons.mark_email_unread_outlined,
                            size: 50.toDouble(),
                            color: ColorConstants.kTextColor,
                          ),
                          const Text(
                            'No Records found',
                            style: TextStyle(
                                letterSpacing: 2,
                                color: ColorConstants.kTextColor),
                          ),
                        ],
                      );
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: bagNumber.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.0),
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Space(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Bag Number',
                                                style: titleStyle(),
                                              ),
                                              Text(
                                                bagNumber[index],
                                                style: textStyle(),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                selectedType == 'Bag Open'
                                                    ? 'Opened Time'
                                                    : 'Closed Time',
                                                style: titleStyle(),
                                              ),
                                              Text(
                                                bagTime[index],
                                                style: textStyle(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      bagArticles.isEmpty
                                          ? Container()
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Space(),
                                                const DottedLine(),
                                                const Space(),
                                                Text(
                                                  'Articles',
                                                  style: titleStyle(),
                                                ),
                                                DataTable(
                                                  columnSpacing: 30,
                                                  columns: const [
                                                    DataColumn(
                                                        label: Text(
                                                            'Article Number',
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                    DataColumn(
                                                        label: Text(
                                                            'Article Type',
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                  ],
                                                  rows: List.generate(
                                                      bagArticles[index].length,
                                                      (articlesIndex) =>
                                                          DataRow(
                                                            cells: <DataCell>[
                                                              DataCell(Text(
                                                                bagArticles[index]
                                                                        [
                                                                        articlesIndex]
                                                                    .toString(),
                                                                style:
                                                                    textStyle(),
                                                              )),
                                                              DataCell(Center(
                                                                  child: Text(
                                                                bagArticleTypes[
                                                                            index]
                                                                        [
                                                                        articlesIndex]
                                                                    .toString(),
                                                                style:
                                                                    textStyle(),
                                                              ))),
                                                            ],
                                                          )),
                                                ),
                                              ],
                                            ),
                                      const Space(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      setState(() {
        var formatter = DateFormat('dd-MM-yyyy');
        dateController.text = formatter.format(d);
      });
    }
  }

  textStyle() {
    return TextStyle(
        letterSpacing: 1,
        fontSize: 13,
        color: ColorConstants.kTextColor,
        fontWeight: FontWeight.w500);
  }

  titleStyle() {
    return TextStyle(
        letterSpacing: 1,
        fontSize: 15,
        color: Colors.blueGrey,
        fontWeight: FontWeight.w500);
  }
}
