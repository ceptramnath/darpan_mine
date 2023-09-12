import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/CustomPackages/TypeAhead/src/flutter_typeahead.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
import 'package:darpan_mine/Mails/Bagging/Service/BaggingDBService.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Mails/Booking/BookingMainScreen.dart';
import 'package:darpan_mine/Mails/Booking/Services/BookingDBService.dart';
import 'package:darpan_mine/Utils/FetchProducts.dart';
import 'package:darpan_mine/Widgets/AppAppBar.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/DialogText.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProductSaleScreen extends StatefulWidget {
  const ProductSaleScreen({Key? key}) : super(key: key);

  @override
  _ProductSaleScreenState createState() => _ProductSaleScreenState();
}

class _ProductSaleScreenState extends State<ProductSaleScreen> {
  bool priceDetails = false;
  bool quantity = false;

  double? totalAmount;

  double? priceOfProduct;
  String stockAvailable = '';
  String saleValue = '';
  String difference = '';
  String productid='';

  final priceFocus = FocusNode();
  final productFocus = FocusNode();
  final stockFocus = FocusNode();
  final quantityFocus = FocusNode();

  final productsController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final quantityController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityProductsController = TextEditingController();
  final payableAmountController = TextEditingController();

  final quantityKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      appBar: const AppAppBar(
        title: 'Product Sale',
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Form(
            key: quantityKey,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                          style: const TextStyle(
                              color: ColorConstants.kSecondaryColor),
                          controller: productsController,
                          autofocus: false,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(
                                MdiIcons.postageStamp,
                                color: ColorConstants.kSecondaryColor,
                              ),
                              fillColor: ColorConstants.kWhite,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorConstants.kWhite),
                              ),
                              labelText: 'Enter the Price/Product Name',
                              labelStyle: TextStyle(
                                  color: ColorConstants.kAmberAccentColor),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorConstants.kWhite)))),
                      onSuggestionSelected:
                          (Map<String, String> suggestion) async {
                        setState(() {
                          productsController.text = suggestion['name']!;
                          priceOfProduct = double.parse(suggestion['price']!);
                          stockAvailable = suggestion['stock']!;
                          productid = suggestion['productid']!;
                        });
                      },
                      itemBuilder: (context, Map<String, String> suggestion) {
                        return ListTile(
                          title: Text('\u{20B9}' +
                              suggestion['price']! +
                              " -> " +
                              suggestion['name']!),
                        );
                      },
                      suggestionsCallback: (pattern) async {
                        return await FetchProducts.getProducts(pattern);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {}
                      },
                    ),
                  ),
                ),
                const Space(),
                Visibility(
                  visible: productsController.text.isEmpty ? false : true,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Flexible(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 10.0),
                                  child: DialogText(
                                    title: 'Price : ',
                                    subtitle: '\u{20B9} $priceOfProduct',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Flexible(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 10.0),
                                  child: DialogText(
                                    title: 'In Stock : ',
                                    subtitle: stockAvailable,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      CInputForm(
                          readOnly: quantity,
                          iconData: MdiIcons.weight,
                          labelText: 'Quantity',
                          controller: quantityController,
                          textType: TextInputType.number,
                          typeValue: 'Quantity',
                          focusNode: quantityFocus),
                      const Space(),
                      Visibility(
                        visible: !priceDetails,
                        child: Button(
                            buttonText: 'CONFIRM',
                            buttonFunction: () {
                              if (quantityKey.currentState!.validate()) {
                                totalAmount = priceOfProduct! *
                                    double.parse(quantityController.text);
                                difference = (double.parse(stockAvailable) -
                                    double.parse(quantityController.text))
                                    .toString();
                                if (double.parse(quantityController.text) >
                                    double.parse(stockAvailable)) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Note!'),
                                          content: const Text(
                                              'Entered quantity is not in the stock.'),
                                          actions: [
                                            Align(
                                                alignment: Alignment.center,
                                                child: Button(
                                                  buttonText: 'OKAY',
                                                  buttonFunction: () =>
                                                      Navigator.pop(context),
                                                ))
                                          ],
                                        );
                                      });
                                }
                                else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Note!'),
                                          content: RichText(
                                            text: TextSpan(
                                              text: 'Would you like to buy ',
                                              style: TextStyle(
                                                  letterSpacing: 1,
                                                  color:
                                                      ColorConstants.kTextColor,
                                                  fontSize: 14),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        productsController.text,
                                                    style: TextStyle(
                                                        color: ColorConstants
                                                            .kTextDark,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14)),
                                                TextSpan(
                                                    text: ' of quantity ',
                                                    style: TextStyle(
                                                        color: ColorConstants
                                                            .kTextColor,
                                                        letterSpacing: 1,
                                                        fontSize: 14)),
                                                TextSpan(
                                                    text:
                                                        quantityController.text,
                                                    style: TextStyle(
                                                        color: ColorConstants
                                                            .kTextDark,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14)),
                                                TextSpan(
                                                    text:
                                                        ' with a total amount of ',
                                                    style: TextStyle(
                                                        color: ColorConstants
                                                            .kTextColor,
                                                        letterSpacing: 1,
                                                        fontSize: 14)),
                                                TextSpan(
                                                    text:
                                                        '\u{20B9}$totalAmount ?',
                                                    style: TextStyle(
                                                        color: ColorConstants
                                                            .kTextDark,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14)),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Button(
                                                    buttonText: 'CANCEL',
                                                    buttonFunction: () =>
                                                        Navigator.pop(context)),
                                                Button(
                                                    buttonText: 'OKAY',
                                                    buttonFunction: () async {

                                                      setState(()  {
                                                        quantity = true;
                                                        priceDetails = true;
                                                        payableAmountController.text =
                                                            (priceOfProduct!*int.parse(quantityController.text))
                                                            .toString();
                                                        print('Payble Amount');
                                                        print(payableAmountController.text);
                                                      });

                                                      if (difference == '0') {
                                                        await ProductsTable().select().Name
                                                            .equals(productsController.text)
                                                        .update({"Quantity":0,"Value":0.0});

                                                        BookingDBService()
                                                            .updateCashInDB(
                                                            double.parse(payableAmountController.text.toString()),
                                                            'Add',productsController.text);

                                                        BookingDBService().addTransaction(
                                                            'BOOK${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}',
                                                            'Stamp',productsController.text,
                                                            DateTimeDetails().currentDate(),
                                                            DateTimeDetails().onlyTime(),
                                                            payableAmountController.text,
                                                            'Add');

                                                        BookingDBService().addProductSaleToDB(
                                                            payableAmountController.text,
                                                            DateTimeDetails().dateCharacter(),
                                                            DateTimeDetails().timeCharacter(),
                                                            priceOfProduct!,
                                                            productid,
                                                            //productsController
                                                            //.text,
                                                            quantityController.text);

                                                      }
                                                      else {

                                                        await ProductsTable().select().ProductID.equals(productid)
                                                        .update({
                                                          "Quantity":double.parse(difference).floor(),
                                                          "Value":(priceOfProduct! * double.parse(difference)).toString()
                                                        });




                                                        BookingDBService()
                                                            .updateCashInDB(
                                                            double.parse(payableAmountController.text.toString()),
                                                            'Add',productsController.text);

                                                        BookingDBService().addTransaction(
                                                            'BOOK${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}',
                                                            'Stamp',productsController.text,
                                                            DateTimeDetails().currentDate(),
                                                            DateTimeDetails().onlyTime(),
                                                            payableAmountController.text,
                                                            'Add');

                                                        BookingDBService().addProductSaleToDB(
                                                            payableAmountController.text,
                                                            DateTimeDetails().dateCharacter(),
                                                            DateTimeDetails().timeCharacter(),
                                                            priceOfProduct!,
                                                            productid,
                                                            //productsController
                                                            //.text,
                                                            quantityController.text);

                                                        // await BaggingDBService()
                                                        //     .addProductsMain(
                                                        //         productsController.text,
                                                        //         priceOfProduct!,
                                                        //         double.parse(difference)
                                                        // );

                                                      }

                                                      Navigator.pop(context);
                                                    })
                                              ],
                                            )
                                          ],
                                        );
                                      });
                                }
                              }
                            }),
                      ),
                    ],
                  ),
                ),
                const DoubleSpace(),
                Visibility(
                  visible: priceDetails,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          InitialTextFormField(
                            labelText: 'Item Name',
                            iconData: Icons.description,
                            controller: productsController,
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: InitialTextFormField(
                                  labelText: 'Quantity',
                                  iconData: MdiIcons.weight,
                                  controller: quantityController,
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: InitialTextFormField(
                                  labelText: 'Payable Amount',
                                  iconData: MdiIcons.currencyInr,
                                  controller: payableAmountController,
                                ),
                              ),
                            ],
                          ),
                          // Button(
                          //     buttonText: 'PRINT',
                          //     buttonFunction: () => {
                          //
                          //
                          //     })
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void conformation() async {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           content: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               DialogText(
  //                   title: 'Invoice Number : ',
  //                   subtitle: 'SL0487040051514392545'),
  //               const Space(),
  //               DialogText(
  //                   title: 'Amount : ',
  //                   subtitle: '\u{20B9} ${payableAmountController.text}')
  //             ],
  //           ),
  //           actions: [
  //             Padding(
  //               padding: const EdgeInsets.only(right: 8.0),
  //               child: ElevatedButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                   Navigator.pushAndRemoveUntil(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (_) => const BookingMainScreen()),
  //                       (route) => false);
  //                 },
  //                 child: const Text('OKAY'),
  //               ),
  //             ),
  //           ],
  //         );
  //       });
  // }
}
