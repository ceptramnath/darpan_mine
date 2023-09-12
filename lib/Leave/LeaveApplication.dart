import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class leaveApplication extends StatefulWidget {
  @override
  _leaveApplicationState createState() => _leaveApplicationState();
}

class _leaveApplicationState extends State<leaveApplication> {
  final leaveReasonController = TextEditingController();
  final employeeIDController = TextEditingController();
  final employeeAddress1Controller = TextEditingController();
  final employeeAddress2Controller = TextEditingController();
  final substituteIDController = TextEditingController();
  final substituteNameController = TextEditingController();
  final substituteAddress1Controller = TextEditingController();
  final substituteAddress2Controller = TextEditingController();
  final substituteQualificationController = TextEditingController();
  final substituteAgeController = TextEditingController();
  final fromdateController = TextEditingController();
  final todateController = TextEditingController();
  final fromdateFocus = FocusNode();
  final todateFocus = FocusNode();
  final employeeIDFocusNode = FocusNode();

  var numberofDays = "";

  List<OFCMASTERDATA> userDetails = [];
  bool _visible = false;
  bool selectedArticle = false;
  var typeArticle = null;
  var selectedLeave;
  final _leaveTypes = ['PAID LEAVE', 'EMERGENCY LEAVE', 'MATERNITY LEAVE'];

  // List<String> maleLeave=["GDS-PAID LEAVE","GDS_LWA","GDS-SPECIAL PAID LEAVE"];
  // List<String> femaleLeave=["GDS-PAID LEAVE","GDS_LWA","GDS-SPECIAL PAID LEAVE","GDS-MATERNITY LEAVE"];

  fetchDetails() async {
    print('fetch User Details in Leave Application..!');
    final activeUser =
        await USERLOGINDETAILS().select().Active.equals(true).toList();

    userDetails = await OFCMASTERDATA()
        .select()
        .EMPID
        .equals(activeUser[0].EMPID)
        .toList();
    print(userDetails.length);
    employeeIDController.text =
        "Employee ID -  " + userDetails[0].EMPID.toString();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: FutureBuilder(
          future: fetchDetails(),
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Space(),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              readOnly: true,
                              focusNode: employeeIDFocusNode,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: employeeIDController,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: ColorConstants.kSecondaryColor,
                                  letterSpacing: 1),
                              textCapitalization: TextCapitalization.characters,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintText: 'Employee ID',
                                  hintStyle: const TextStyle(
                                      color: ColorConstants.kAmberAccentColor),
                                  counterText: '',
                                  fillColor: ColorConstants.kWhite,
                                  filled: true,
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorConstants.kWhite),
                                  ),
                                  prefixIcon: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.toDouble()),
                                      margin: EdgeInsets.only(
                                          right: 8.0.toDouble()),
                                      decoration: const BoxDecoration(
                                        color: ColorConstants.kSecondaryColor,
                                      ),
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          MdiIcons.accountEye,
                                          color: ColorConstants.kWhite,
                                          size: 30,
                                        ),
                                      )),
                                  contentPadding:
                                      EdgeInsets.all(15.0.toDouble()),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: ColorConstants.kWhite),
                                      borderRadius: BorderRadius.only(
                                        topLeft:
                                            Radius.circular(20.0.toDouble()),
                                        bottomLeft:
                                            Radius.circular(30.0.toDouble()),
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: ColorConstants.kWhite),
                                      borderRadius: BorderRadius.only(
                                        topLeft:
                                            Radius.circular(20.0.toDouble()),
                                        bottomLeft:
                                            Radius.circular(30.0.toDouble()),
                                      ))),
                              validator: (text) {
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SmallSpace(),
                      const Divider(),
                      Center(child: leaveTable()),
                      const Divider(),
                      const SmallSpace(),
                      //Add Leave field
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3.toDouble()),
                                    decoration: const BoxDecoration(
                                      color: ColorConstants.kSecondaryColor,
                                    ),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.horizontal_split_outlined,
                                        color: ColorConstants.kWhite,
                                      ),
                                    )),
                                Expanded(
                                  child: Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 10),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            iconEnabledColor: Colors.blueGrey,
                                            hint: const Text(
                                              'Leave Type',
                                              style: TextStyle(
                                                  color: Color(0xFFCFB53B)),
                                            ),
                                            items: _leaveTypes
                                                .map((String myMenuItem) {
                                              return DropdownMenuItem<String>(
                                                value: myMenuItem,
                                                child: Text(
                                                  myMenuItem,
                                                  style: const TextStyle(
                                                      color: Colors.blueGrey),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (String?
                                                valueSelectedByUser) async {
                                              print(selectedLeave);
                                              print(valueSelectedByUser
                                                  .toString());
                                              setState(() {
                                                selectedLeave =
                                                    valueSelectedByUser;
                                                _visible = true;
                                              });
                                              print(selectedLeave);
                                            },
                                            value: selectedLeave,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      const SmallSpace(),

                      Visibility(
                        visible: _visible,
                        child: Column(
                          children: [
                            //From & To date picker
                            Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: YearForm(
                                        title: 'From',
                                        selectYear: () {
                                          _selectFromDate(context);
                                        },
                                        controller: fromdateController,
                                        focusNode: fromdateFocus)),
                                Expanded(
                                    flex: 2,
                                    child: YearForm(
                                        title: 'To',
                                        selectYear: () {
                                          _selectToDate(context);
                                        },
                                        controller: todateController,
                                        focusNode: todateFocus)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "No. of Days - $numberofDays",
                                  style: TextStyle(
                                      color: Colors.blueGrey, fontSize: 12),
                                ),
                              ],
                            ),
                            const Divider(),
                            const SmallSpace(),

                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: TextFormField(
                                    readOnly: true,
                                    // focusNode: employeeIDFocusNode,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: leaveReasonController,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: ColorConstants.kSecondaryColor,
                                        letterSpacing: 1),
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintText: 'Reason*',
                                        hintStyle: const TextStyle(
                                            color: ColorConstants
                                                .kAmberAccentColor),
                                        counterText: '',
                                        fillColor: ColorConstants.kWhite,
                                        filled: true,
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorConstants.kWhite),
                                        ),
                                        // prefixIcon: Container(
                                        //     padding: EdgeInsets.symmetric(
                                        //         vertical: 5.toDouble()),
                                        //     margin: EdgeInsets.only(
                                        //         right: 8.0.toDouble()),
                                        //     decoration: const BoxDecoration(
                                        //       color: ColorConstants.kSecondaryColor,
                                        //     ),
                                        //     child: IconButton(
                                        //       onPressed: () {},
                                        //       icon: const Icon(
                                        //         MdiIcons.text,
                                        //         color: ColorConstants.kWhite,
                                        //         size: 30,
                                        //       ),
                                        //     )),
                                        contentPadding:
                                            EdgeInsets.all(15.0.toDouble()),
                                        isDense: true,
                                        border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ColorConstants.kWhite),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  20.0.toDouble()),
                                              bottomLeft: Radius.circular(
                                                  30.0.toDouble()),
                                            )),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ColorConstants.kWhite),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  20.0.toDouble()),
                                              bottomLeft: Radius.circular(
                                                  30.0.toDouble()),
                                            ))),
                                    validator: (text) {
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SmallSpace(),
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: TextFormField(
                                    readOnly: true,
                                    // focusNode: employeeIDFocusNode,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: employeeAddress1Controller,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: ColorConstants.kSecondaryColor,
                                        letterSpacing: 1),
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintText: 'Employee Address1*',
                                        hintStyle: const TextStyle(
                                            color: ColorConstants
                                                .kAmberAccentColor),
                                        counterText: '',
                                        fillColor: ColorConstants.kWhite,
                                        filled: true,
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorConstants.kWhite),
                                        ),
                                        prefixIcon: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.toDouble()),
                                            margin: EdgeInsets.only(
                                                right: 8.0.toDouble()),
                                            decoration: const BoxDecoration(
                                              color: ColorConstants
                                                  .kSecondaryColor,
                                            ),
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                MdiIcons.crosshairsGps,
                                                color: ColorConstants.kWhite,
                                                size: 30,
                                              ),
                                            )),
                                        contentPadding:
                                            EdgeInsets.all(15.0.toDouble()),
                                        isDense: true,
                                        border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ColorConstants.kWhite),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  20.0.toDouble()),
                                              bottomLeft: Radius.circular(
                                                  30.0.toDouble()),
                                            )),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ColorConstants.kWhite),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  20.0.toDouble()),
                                              bottomLeft: Radius.circular(
                                                  30.0.toDouble()),
                                            ))),
                                    validator: (text) {
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SmallSpace(),
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: TextFormField(
                                    readOnly: true,
                                    // focusNode: employeeIDFocusNode,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: employeeAddress2Controller,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: ColorConstants.kSecondaryColor,
                                        letterSpacing: 1),
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintText: 'Employee Address2*',
                                        hintStyle: const TextStyle(
                                            color: ColorConstants
                                                .kAmberAccentColor),
                                        counterText: '',
                                        fillColor: ColorConstants.kWhite,
                                        filled: true,
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorConstants.kWhite),
                                        ),
                                        prefixIcon: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.toDouble()),
                                            margin: EdgeInsets.only(
                                                right: 8.0.toDouble()),
                                            decoration: const BoxDecoration(
                                              color: ColorConstants
                                                  .kSecondaryColor,
                                            ),
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                MdiIcons.navigationOutline,
                                                color: ColorConstants.kWhite,
                                                size: 30,
                                              ),
                                            )),
                                        contentPadding:
                                            EdgeInsets.all(15.0.toDouble()),
                                        isDense: true,
                                        border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ColorConstants.kWhite),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  20.0.toDouble()),
                                              bottomLeft: Radius.circular(
                                                  30.0.toDouble()),
                                            )),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ColorConstants.kWhite),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  20.0.toDouble()),
                                              bottomLeft: Radius.circular(
                                                  30.0.toDouble()),
                                            ))),
                                    validator: (text) {
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SmallSpace(),
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: TextFormField(
                                    readOnly: true,
                                    // focusNode: employeeIDFocusNode,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: substituteIDController,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: ColorConstants.kSecondaryColor,
                                        letterSpacing: 1),
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintText: 'Substitute ID',
                                        hintStyle: const TextStyle(
                                            color: ColorConstants
                                                .kAmberAccentColor),
                                        counterText: '',
                                        fillColor: ColorConstants.kWhite,
                                        filled: true,
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorConstants.kWhite),
                                        ),
                                        prefixIcon: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.toDouble()),
                                            margin: EdgeInsets.only(
                                                right: 8.0.toDouble()),
                                            decoration: const BoxDecoration(
                                              color: ColorConstants
                                                  .kSecondaryColor,
                                            ),
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                MdiIcons.navigationOutline,
                                                color: ColorConstants.kWhite,
                                                size: 30,
                                              ),
                                            )),
                                        contentPadding:
                                            EdgeInsets.all(15.0.toDouble()),
                                        isDense: true,
                                        border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ColorConstants.kWhite),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  20.0.toDouble()),
                                              bottomLeft: Radius.circular(
                                                  30.0.toDouble()),
                                            )),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ColorConstants.kWhite),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  20.0.toDouble()),
                                              bottomLeft: Radius.circular(
                                                  30.0.toDouble()),
                                            ))),
                                    validator: (text) {
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SmallSpace(),
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: TextFormField(
                                    readOnly: true,
                                    // focusNode: employeeIDFocusNode,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: substituteNameController,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: ColorConstants.kSecondaryColor,
                                        letterSpacing: 1),
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintText: 'Substitute Name',
                                        hintStyle: const TextStyle(
                                            color: ColorConstants
                                                .kAmberAccentColor),
                                        counterText: '',
                                        fillColor: ColorConstants.kWhite,
                                        filled: true,
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorConstants.kWhite),
                                        ),
                                        prefixIcon: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.toDouble()),
                                            margin: EdgeInsets.only(
                                                right: 8.0.toDouble()),
                                            decoration: const BoxDecoration(
                                              color: ColorConstants
                                                  .kSecondaryColor,
                                            ),
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                MdiIcons.navigationOutline,
                                                color: ColorConstants.kWhite,
                                                size: 30,
                                              ),
                                            )),
                                        contentPadding:
                                            EdgeInsets.all(15.0.toDouble()),
                                        isDense: true,
                                        border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ColorConstants.kWhite),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  20.0.toDouble()),
                                              bottomLeft: Radius.circular(
                                                  30.0.toDouble()),
                                            )),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ColorConstants.kWhite),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  20.0.toDouble()),
                                              bottomLeft: Radius.circular(
                                                  30.0.toDouble()),
                                            ))),
                                    validator: (text) {
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SmallSpace(),
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: TextFormField(
                                    readOnly: true,
                                    // focusNode: employeeIDFocusNode,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: substituteAddress1Controller,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: ColorConstants.kSecondaryColor,
                                        letterSpacing: 1),
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintText: 'Substitute Address1*',
                                        hintStyle: const TextStyle(
                                            color: ColorConstants
                                                .kAmberAccentColor),
                                        counterText: '',
                                        fillColor: ColorConstants.kWhite,
                                        filled: true,
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorConstants.kWhite),
                                        ),
                                        prefixIcon: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.toDouble()),
                                            margin: EdgeInsets.only(
                                                right: 8.0.toDouble()),
                                            decoration: const BoxDecoration(
                                              color: ColorConstants
                                                  .kSecondaryColor,
                                            ),
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                MdiIcons.navigationOutline,
                                                color: ColorConstants.kWhite,
                                                size: 30,
                                              ),
                                            )),
                                        contentPadding:
                                            EdgeInsets.all(15.0.toDouble()),
                                        isDense: true,
                                        border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ColorConstants.kWhite),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  20.0.toDouble()),
                                              bottomLeft: Radius.circular(
                                                  30.0.toDouble()),
                                            )),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ColorConstants.kWhite),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  20.0.toDouble()),
                                              bottomLeft: Radius.circular(
                                                  30.0.toDouble()),
                                            ))),
                                    validator: (text) {
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SmallSpace(),
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: TextFormField(
                                    readOnly: true,
                                    // focusNode: employeeIDFocusNode,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: substituteAddress2Controller,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: ColorConstants.kSecondaryColor,
                                        letterSpacing: 1),
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintText: 'Substitute Address2*',
                                        hintStyle: const TextStyle(
                                            color: ColorConstants
                                                .kAmberAccentColor),
                                        counterText: '',
                                        fillColor: ColorConstants.kWhite,
                                        filled: true,
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorConstants.kWhite),
                                        ),
                                        prefixIcon: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.toDouble()),
                                            margin: EdgeInsets.only(
                                                right: 8.0.toDouble()),
                                            decoration: const BoxDecoration(
                                              color: ColorConstants
                                                  .kSecondaryColor,
                                            ),
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                MdiIcons.navigationOutline,
                                                color: ColorConstants.kWhite,
                                                size: 30,
                                              ),
                                            )),
                                        contentPadding:
                                            EdgeInsets.all(15.0.toDouble()),
                                        isDense: true,
                                        border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ColorConstants.kWhite),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  20.0.toDouble()),
                                              bottomLeft: Radius.circular(
                                                  30.0.toDouble()),
                                            )),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ColorConstants.kWhite),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  20.0.toDouble()),
                                              bottomLeft: Radius.circular(
                                                  30.0.toDouble()),
                                            ))),
                                    validator: (text) {
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SmallSpace(),
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: TextFormField(
                                    readOnly: true,
                                    // focusNode: employeeIDFocusNode,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller:
                                        substituteQualificationController,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: ColorConstants.kSecondaryColor,
                                        letterSpacing: 1),
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintText: 'Substitute Qualification',
                                        hintStyle: const TextStyle(
                                            color: ColorConstants
                                                .kAmberAccentColor),
                                        counterText: '',
                                        fillColor: ColorConstants.kWhite,
                                        filled: true,
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorConstants.kWhite),
                                        ),
                                        prefixIcon: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.toDouble()),
                                            margin: EdgeInsets.only(
                                                right: 8.0.toDouble()),
                                            decoration: const BoxDecoration(
                                              color: ColorConstants
                                                  .kSecondaryColor,
                                            ),
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                MdiIcons.navigationOutline,
                                                color: ColorConstants.kWhite,
                                                size: 30,
                                              ),
                                            )),
                                        contentPadding:
                                            EdgeInsets.all(15.0.toDouble()),
                                        isDense: true,
                                        border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ColorConstants.kWhite),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  20.0.toDouble()),
                                              bottomLeft: Radius.circular(
                                                  30.0.toDouble()),
                                            )),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ColorConstants.kWhite),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  20.0.toDouble()),
                                              bottomLeft: Radius.circular(
                                                  30.0.toDouble()),
                                            ))),
                                    validator: (text) {
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SmallSpace(),
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: TextFormField(
                                    readOnly: true,
                                    // focusNode: employeeIDFocusNode,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: substituteAgeController,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: ColorConstants.kSecondaryColor,
                                        letterSpacing: 1),
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintText: 'Substitute Age',
                                        hintStyle: const TextStyle(
                                            color: ColorConstants
                                                .kAmberAccentColor),
                                        counterText: '',
                                        fillColor: ColorConstants.kWhite,
                                        filled: true,
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorConstants.kWhite),
                                        ),
                                        prefixIcon: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.toDouble()),
                                            margin: EdgeInsets.only(
                                                right: 8.0.toDouble()),
                                            decoration: const BoxDecoration(
                                              color: ColorConstants
                                                  .kSecondaryColor,
                                            ),
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                MdiIcons.navigationOutline,
                                                color: ColorConstants.kWhite,
                                                size: 30,
                                              ),
                                            )),
                                        contentPadding:
                                            EdgeInsets.all(15.0.toDouble()),
                                        isDense: true,
                                        border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ColorConstants.kWhite),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  20.0.toDouble()),
                                              bottomLeft: Radius.circular(
                                                  30.0.toDouble()),
                                            )),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ColorConstants.kWhite),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  20.0.toDouble()),
                                              bottomLeft: Radius.circular(
                                                  30.0.toDouble()),
                                            ))),
                                    validator: (text) {
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SmallSpace(),

                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          ColorConstants.kWhite),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.toDouble()),
                                          side: const BorderSide(
                                              color: ColorConstants
                                                  .kSecondaryColor)))),
                              onPressed: () {},
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0.toDouble()),
                                child: const Text(
                                  'SUBMIT',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: ColorConstants.kAmberAccentColor),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  Widget leaveTable() {
    return DataTable(
      border: TableBorder.all(
        width: 2,
        color: Colors.blueGrey,
      ),
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            flex: 3,
            child: Text(
              'Leave Type',
              style: TextStyle(
                  fontStyle: FontStyle.italic, color: Colors.blueGrey),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            flex: 2,
            child: Text(
              'Available',
              style: TextStyle(
                  fontStyle: FontStyle.italic, color: Colors.blueGrey),
            ),
          ),
        ),
      ],
      rows: <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text('PAID LEAVE')),
            DataCell(Text(userDetails[0].PAIDLEAVE.toString())),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('EMERGENCY LEAVE')),
            DataCell(Text(userDetails[0].EMGLEAVE.toString())),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('MATERNITY LEAVE')),
            DataCell(Text(userDetails[0].MATERNITYLEAVE.toString())),
          ],
        ),
      ],
    );
  }

  _selectFromDate(BuildContext context) async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2200),
    );
    if (d != null) {
      setState(() {
        var formatter = DateFormat('dd-MM-yyyy');
        fromdateController.text = formatter.format(d);
      });
    }
  }

  _selectToDate(BuildContext context) async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2200),
    );
    if (d != null) {
      setState(() {
        var formatter = DateFormat('dd-MM-yyyy');
        todateController.text = formatter.format(d);
      });
    }
  }
}
