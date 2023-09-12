import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Constants/Texts.dart';
import 'package:darpan_mine/CustomPackages/TypeAhead/src/flutter_typeahead.dart';
import 'package:darpan_mine/Utils/FetchPin.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/DialogText.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ApplyLeaveScreen extends StatefulWidget {
  const ApplyLeaveScreen({Key? key}) : super(key: key);

  @override
  _ApplyLeaveScreenState createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  String date = "";

  Color substituteHeadingColor = ColorConstants.kPrimaryAccent;

  DateTime selectedDate = DateTime.now();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  bool isLoading = false;
  bool substituteFormOpenFlag = false;

  var _selectedGenderIndex;
  var _chosenMsg;
  var totalLeaves = '';

  final gdsController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  final leavesController = TextEditingController();
  final substituteIDController = TextEditingController();
  final substituteNameController = TextEditingController();
  final substituteAgeController = TextEditingController();
  final substituteAddressController = TextEditingController();
  final substitutePinCodeController = TextEditingController();
  final substituteCityController = TextEditingController();
  final substituteStateController = TextEditingController();
  final substituteQualificationController = TextEditingController();

  final gdsFocus = FocusNode();
  final fromFocus = FocusNode();
  final toFocus = FocusNode();
  final substituteIdFocus = FocusNode();
  final substituteNameFocus = FocusNode();
  final substituteAgeFocus = FocusNode();
  final substituteAddressFocus = FocusNode();
  final substitutePinCodeFocus = FocusNode();
  final substituteCityFocus = FocusNode();
  final substituteStateFocus = FocusNode();
  final substituteQualificationFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CInputForm(
                  readOnly: false,
                  iconData: MdiIcons.idCard,
                  labelText: 'GDS ID',
                  controller: gdsController,
                  textType: TextInputType.text,
                  typeValue: 'GDS',
                  focusNode: gdsFocus),
              Space(),
              Text(
                'Gender',
                style: TextStyle(
                    color: ColorConstants.kTextColor,
                    fontSize: 15,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500),
              ),
              Space(),
              Wrap(
                children: _genderChip(),
              ),
              DoubleSpace(),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _chosenMsg,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: ColorConstants.kSecondaryColor),
                items:
                    holidayLeaves.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text(
                  "Select the Reason to Apply Leave",
                  style: TextStyle(
                    color: ColorConstants.kAmberAccentColor,
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _chosenMsg = value;
                  });
                },
              ),
              Space(),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: YearForm(
                        title: 'From Date',
                        selectYear: () {
                          _selectDate(context, 'from');
                        },
                        controller: fromDateController,
                        focusNode: fromFocus),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: YearForm(
                        title: 'To Date',
                        selectYear: () {
                          _selectDate(context, 'to');
                        },
                        controller: toDateController,
                        focusNode: toFocus),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Visibility(
                  visible: toDateController.text.isNotEmpty &&
                          fromDateController.text.isNotEmpty
                      ? true
                      : false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Colors.blueGrey,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            DialogText(
                                title: 'Number of Days : ',
                                subtitle: daysBetween(fromDate, toDate))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ExpansionTile(
                initiallyExpanded: substituteFormOpenFlag,
                title: Text(
                  'Substitute Details',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: substituteHeadingColor,
                      fontSize: 20.toDouble(),
                      letterSpacing: 1),
                ),
                trailing: (substituteFormOpenFlag == false)
                    ? Icon(
                        MdiIcons.toggleSwitchOffOutline,
                        size: 40.toDouble(),
                        color: ColorConstants.kTextColor,
                      )
                    : Icon(MdiIcons.toggleSwitchOutline,
                        size: 40.toDouble(),
                        color: ColorConstants.kPrimaryAccent),
                onExpansionChanged: (value) {
                  setState(() {
                    substituteFormOpenFlag = value;
                  });
                },
                children: [
                  CInputForm(
                    readOnly: false,
                    iconData: MdiIcons.identifier,
                    labelText: 'ID',
                    controller: substituteIDController,
                    textType: TextInputType.text,
                    typeValue: 'Id',
                    focusNode: substituteIdFocus,
                  ),
                  CInputForm(
                    readOnly: false,
                    iconData: Icons.person,
                    labelText: 'Name',
                    controller: substituteNameController,
                    textType: TextInputType.text,
                    typeValue: 'Name',
                    focusNode: substituteNameFocus,
                  ),
                  CInputForm(
                    readOnly: false,
                    iconData: Icons.person,
                    labelText: 'Age',
                    controller: substituteAgeController,
                    textType: TextInputType.text,
                    typeValue: 'Age',
                    focusNode: substituteAgeFocus,
                  ),
                  CInputForm(
                    readOnly: false,
                    iconData: MdiIcons.home,
                    labelText: 'Address',
                    controller: substituteAddressController,
                    textType: TextInputType.multiline,
                    typeValue: 'Address',
                    focusNode: substituteAddressFocus,
                  ),
                  Card(
                    elevation: 0,
                    child: TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                          style:
                              TextStyle(color: ColorConstants.kSecondaryColor),
                          controller: substitutePinCodeController,
                          autofocus: false,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.location_on_outlined,
                                color: ColorConstants.kSecondaryColor,
                              ),
                              fillColor: ColorConstants.kWhite,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorConstants.kWhite),
                              ),
                              labelText: 'Pincode/Office Name *',
                              labelStyle: TextStyle(
                                  color: ColorConstants.kAmberAccentColor),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorConstants.kWhite)))),
                      onSuggestionSelected:
                          (Map<String, String> suggestion) async {
                        substitutePinCodeController.text =
                            suggestion['pinCode']!;
                        substituteCityController.text = suggestion['city']!;
                        substituteStateController.text = suggestion['state']!;
                      },
                      itemBuilder: (context, Map<String, String> suggestion) {
                        return ListTile(
                          title: Text(suggestion['officeName']! +
                              ", " +
                              suggestion['pinCode']!),
                        );
                      },
                      suggestionsCallback: (pattern) async {
                        return await FetchPin.getSuggestions(pattern);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          isLoading = false;
                          return 'Select a Pincode/Office name';
                        }
                      },
                    ),
                  ),
                  Visibility(
                    visible:
                        substitutePinCodeController.text.isEmpty ? false : true,
                    child: CInputForm(
                      readOnly: true,
                      iconData: Icons.location_city,
                      labelText: 'City',
                      controller: substituteCityController,
                      textType: TextInputType.text,
                      typeValue: 'City',
                      focusNode: substituteCityFocus,
                    ),
                  ),
                  Visibility(
                    visible:
                        substitutePinCodeController.text.isEmpty ? false : true,
                    child: CInputForm(
                      readOnly: true,
                      iconData: Icons.location_city,
                      labelText: 'State',
                      controller: substituteStateController,
                      textType: TextInputType.text,
                      typeValue: 'City',
                      focusNode: substituteStateFocus,
                    ),
                  ),
                  CInputForm(
                    readOnly: false,
                    iconData: MdiIcons.bookEducation,
                    labelText: 'Qualification',
                    controller: substituteQualificationController,
                    textType: TextInputType.text,
                    typeValue: 'Qualification',
                    focusNode: substituteQualificationFocus,
                  )
                ],
              ),
              Align(
                  alignment: Alignment.center,
                  child:
                      Button(buttonText: 'Apply Leave', buttonFunction: () {}))
            ],
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context, String type) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      final String formattedDate = formatter.format(selected);
      setState(() {
        if (type == 'from') {
          fromDateController.text = formattedDate;
          setState(() {
            fromDate = selected;
          });
        } else if (type == 'to') {
          toDateController.text = formattedDate;
          setState(() {
            toDate = selected;
          });
        }
      });
    }
  }

  daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    totalLeaves = (to.difference(from).inHours / 24).round().toString();
    return totalLeaves;
  }

  _genderChip() {
    List<Widget> chips = [];
    for (int i = 0; i < gender.length; i++) {
      ChoiceChip chip = ChoiceChip(
        avatar: Icon(Icons.person),
        label: Text(gender[i]),
        labelStyle: TextStyle(
            fontSize: 15.toDouble(),
            color: Colors.black54,
            letterSpacing: 1),
        selected: _selectedGenderIndex == i,
        elevation: 5,
        pressElevation: 5,
        shadowColor: Colors.black54,
        backgroundColor: Colors.white,
        selectedColor: Colors.redAccent.withOpacity(.2),
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedGenderIndex = i;
            }
          });
        },
      );
      chips.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.toDouble()),
        child: chip,
      ));
    }
    return chips;
  }

  applyLeave() {}
}
