import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Constants/Texts.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/Utils/Printing.dart';
import 'package:darpan_mine/Widgets/AppAppBar.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/DottedLine.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';

class PayRollScreen extends StatefulWidget {
  const PayRollScreen({Key? key}) : super(key: key);

  @override
  _PayRollScreenState createState() => _PayRollScreenState();
}

class _PayRollScreenState extends State<PayRollScreen> {
  bool paySlip = false;

  var _chosenMonth;

  List<PaySlipData> PSD = [];

  final gdsController = TextEditingController();
  final yearController = TextEditingController();

  final gdsFocus = FocusNode();
  final yearFocus = FocusNode();

  //List? PaySlipDetails = [];

  DateTime selectedDate = DateTime.now();

  List<String>? get basicInformation => null;

  _selectDate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Year"),
          content: Container(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(DateTime.now().year - 100, 1),
              lastDate: DateTime(DateTime.now().year + 100, 1),
              initialDate: DateTime.now(),
              selectedDate: DateTime.now(),
              onChanged: (DateTime dateTime) {
                Navigator.pop(context);
                setState(() {
                  yearController.text = dateTime.year.toString();
                });
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      appBar: AppAppBar(
        title: 'PayRoll',
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
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
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _chosenMonth,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: ColorConstants.kSecondaryColor),
                items: months.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text(
                  "Select the Month",
                  style: TextStyle(
                    color: ColorConstants.kAmberAccentColor,
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _chosenMonth = value;
                  });
                },
              ),
              Space(),
              YearForm(
                title: 'Select Year',
                controller: yearController,
                focusNode: yearFocus,
                selectYear: () => _selectDate(),
              ),
              const DoubleSpace(),

              Button(
                  buttonText: 'SUBMIT',
                  buttonFunction: () async {
                    PSD = await PaySlipData()
                        .select()
                        .EMPLOYEE_ID
                        .equals(gdsController.text)
                        .and
                        .startBlock
                        .MONTH
                        .equals(_chosenMonth)
                        .and
                        .YEAR
                        .equals(yearController.text)
                        .endBlock
                        .toList();
                    if (PSD.length > 0) {
                      setState(() {
                        paySlip = true;
                      });
                    } else {
                      setState(() {
                        paySlip = false;
                      });

                    UtilFs.showToast("No data available for the selected combination",context);
                      print("No data available for the selected month");
                    }

                  }),
              // ],

              const DoubleSpace(),

              paySlip == true
                  ? Column(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Image.asset(
                                            'assets/images/ic_logo.png')),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Department of Posts',
                                            style: TextStyle(
                                                fontSize: 20,
                                                letterSpacing: 2,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            // 'Payslip for December 2021',
                                            //  'Payslip for' + _chosenMonth+' '+yearController.text,
                                            "Payslip for $_chosenMonth ${yearController.text}",
                                            style: TextStyle(letterSpacing: 2),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Space(),
                                DottedLine(),
                                Space(),

                                PSD[0].EMPLOYEE_ID.toString() != ''
                                    ? slipRow('EMPLOYEE_ID',
                                        PSD[0].EMPLOYEE_ID.toString())
                                    : SizedBox(),
                                PSD[0].EMPLOYEE_NAME.toString() != ''
                                    ? slipRow('EMPLOYEE_NAME',
                                        PSD[0].EMPLOYEE_NAME.toString())
                                    : SizedBox(),
                                PSD[0].OFFICE.toString() != ''
                                    ? slipRow('OFFICE', PSD[0].OFFICE.toString())
                                    : SizedBox(),
                                PSD[0].POSITION.toString() != ''
                                    ? slipRow(
                                    'POSITION', PSD[0].POSITION.toString())
                                    : SizedBox(),
                                PSD[0].MONTH.toString() != ''
                                    ? slipRow('MONTH', PSD[0].MONTH.toString())
                                    : SizedBox(),
                                PSD[0].YEAR.toString() != '' ? slipRow(
                                    'YEAR', PSD[0].YEAR.toString()) : SizedBox(),
                                PSD[0].ACCOUNT_NUMBER.toString() != ''
                                    ? slipRow('ACCOUNT_NUMBER',
                                    PSD[0].ACCOUNT_NUMBER.toString())
                                    : SizedBox(),
                                PSD[0].TRCA.toString() != '' ? slipRow(
                                    'TRCA', PSD[0].TRCA.toString()) : SizedBox(),
                                PSD[0].DEARNESS_ALLOWANCE.toString() != ''
                                    ? slipRow('DEARNESS_ALLOWANCE',
                                    PSD[0].DEARNESS_ALLOWANCE.toString())
                                    : SizedBox(),
                                PSD[0].FIXED_STATIONERY_CHARGES.toString() != ''
                                    ? slipRow('FIXED_STATIONERY_CHARGES',
                                    PSD[0].FIXED_STATIONERY_CHARGES.toString())
                                    : SizedBox(),
                                PSD[0].BOAT_ALLOWANCE.toString() != ''
                                    ? slipRow('BOAT_ALLOWANCE',
                                    PSD[0].BOAT_ALLOWANCE.toString())
                                    : SizedBox(),
                                PSD[0].CYCLE_MAINTENANCE_ALLOWANCE.toString() !=
                                    ''
                                    ? slipRow('CYCLE_MAINTENANCE_ALLOWANCE',
                                    PSD[0].CYCLE_MAINTENANCE_ALLOWANCE.toString())
                                    : SizedBox(),
                                PSD[0].OFFICE_MAINTENANCE_ALLOWANCE.toString() !=
                                    '' ? slipRow('OFFICE_MAINTENANCE_ALLOWANCE',
                                    PSD[0].OFFICE_MAINTENANCE_ALLOWANCE
                                        .toString()) : SizedBox(),
                                PSD[0].CDA.toString() != '' ? slipRow(
                                    'CDA', PSD[0].CDA.toString()) : SizedBox(),
                                PSD[0].COMBINATION_DELIVERY_ALLOWANCE
                                    .toString() != '' ? slipRow(
                                    'COMBINATION_DELIVERY_ALLOWANCE',
                                    PSD[0].COMBINATION_DELIVERY_ALLOWANCE
                                        .toString()) : SizedBox(),
                                PSD[0].COMPENSATION_MAIL_CARRIER.toString() != ''
                                    ? slipRow('COMPENSATION_MAIL_CARRIER',
                                    PSD[0].COMPENSATION_MAIL_CARRIER.toString())
                                    : SizedBox(),
                                PSD[0].RETAINERSHIP_ALLOWANCE.toString() != ''
                                    ? slipRow('RETAINERSHIP_ALLOWANCE',
                                    PSD[0].RETAINERSHIP_ALLOWANCE.toString())
                                    : SizedBox(),
                                PSD[0].CASH_CONVEYANCE_ALLOWANCE.toString() != ''
                                    ? slipRow('CASH_CONVEYANCE_ALLOWANCE',
                                    PSD[0].CASH_CONVEYANCE_ALLOWANCE.toString())
                                    : SizedBox(),
                                PSD[0].PERSONAL_ALLOWANCE_GDS.toString() != ''
                                    ? slipRow('PERSONAL_ALLOWANCE_GDS',
                                    PSD[0].PERSONAL_ALLOWANCE_GDS.toString())
                                    : SizedBox(),
                                PSD[0].BONUS_GDS.toString() != ''
                                    ? slipRow(
                                    'BONUS_GDS', PSD[0].BONUS_GDS.toString())
                                    : SizedBox(),
                                PSD[0].EXGRATIA_GRATUITY.toString() != ''
                                    ? slipRow('EXGRATIA_GRATUITY',
                                    PSD[0].EXGRATIA_GRATUITY.toString())
                                    : SizedBox(),
                                PSD[0].SEVERANCE_AMOUNT.toString() != ''
                                    ? slipRow('SEVERANCE_AMOUNT',
                                    PSD[0].SEVERANCE_AMOUNT.toString())
                                    : SizedBox(),
                                PSD[0].INCENTIVES.toString() != ''
                                    ? slipRow(
                                    'INCENTIVES', PSD[0].INCENTIVES.toString())
                                    : SizedBox(),
                                PSD[0].DA_ARREARS_GDS.toString() != ''
                                    ? slipRow('DA_ARREARS_GDS',
                                    PSD[0].DA_ARREARS_GDS.toString())
                                    : SizedBox(),
                                PSD[0].TOTAL_EARNINGS.toString() != ''
                                    ? slipRow('TOTAL_EARNINGS',
                                    PSD[0].TOTAL_EARNINGS.toString())
                                    : SizedBox(),
                                PSD[0].TRCA_ALLOWANCE_ARREARS.toString() != ''
                                    ? slipRow('TRCA_ALLOWANCE_ARREARS',
                                    PSD[0].TRCA_ALLOWANCE_ARREARS.toString())
                                    : SizedBox(),
                                PSD[0].DEARNESS_ALLOWANCE_ARREAR.toString() != ''
                                    ? slipRow('DEARNESS_ALLOWANCE_ARREAR',
                                    PSD[0].DEARNESS_ALLOWANCE_ARREAR.toString())
                                    : SizedBox(),
                                PSD[0].DEARNESS_RELIEF_CDAARREAR.toString() != ''
                                    ? slipRow('DEARNESS_RELIEF_CDAARREAR',
                                    PSD[0].DEARNESS_RELIEF_CDAARREAR.toString())
                                    : SizedBox(),
                                PSD[0].TOTAL_ARREARS.toString() != '' ? slipRow(
                                    'TOTAL_ARREARS',
                                    PSD[0].TOTAL_ARREARS.toString()) : SizedBox(),
                                PSD[0].COURT_ATTACHMENT_ODFM.toString() != ''
                                    ? slipRow('COURT_ATTACHMENT_ODFM',
                                    PSD[0].COURT_ATTACHMENT_ODFM.toString())
                                    : SizedBox(),
                                PSD[0].RD.toString() != '' ? slipRow(
                                    'RD', PSD[0].RD.toString()) : SizedBox(),
                                PSD[0].COURT_ATTACHMENT_DFM.toString() != ''
                                    ? slipRow('COURT_ATTACHMENT_DFM',
                                    PSD[0].COURT_ATTACHMENT_DFM.toString())
                                    : SizedBox(),
                                PSD[0].LICENSE_FEE.toString() != ''
                                    ? slipRow(
                                    'LICENSE_FEE', PSD[0].LICENSE_FEE.toString())
                                    : SizedBox(),
                                PSD[0].SDBS.toString() != '' ? slipRow(
                                    'SDBS', PSD[0].SDBS.toString()) : SizedBox(),
                                PSD[0].AUDIT_OFFICE_RECOVERY.toString() != ''
                                    ? slipRow('AUDIT_OFFICE_RECOVERY',
                                    PSD[0].AUDIT_OFFICE_RECOVERY.toString())
                                    : SizedBox(),
                                PSD[0].COOP_CREDIT_SOCIETY.toString() != ''
                                    ? slipRow('COOP_CREDIT_SOCIETY',
                                    PSD[0].COOP_CREDIT_SOCIETY.toString())
                                    : SizedBox(),
                                PSD[0].RELIEF_FUND.toString() != ''
                                    ? slipRow(
                                    'RELIEF_FUND', PSD[0].RELIEF_FUND.toString())
                                    : SizedBox(),
                                PSD[0].DEATH_RELIEF_FUND.toString() != ''
                                    ? slipRow('DEATH_RELIEF_FUND',
                                    PSD[0].DEATH_RELIEF_FUND.toString())
                                    : SizedBox(),
                                PSD[0].WATER_TAX.toString() != ''
                                    ? slipRow(
                                    'WATER_TAX', PSD[0].WATER_TAX.toString())
                                    : SizedBox(),
                                PSD[0].ELECTRICITY_CHARGES.toString() != ''
                                    ? slipRow('ELECTRICITY_CHARGES',
                                    PSD[0].ELECTRICITY_CHARGES.toString())
                                    : SizedBox(),
                                PSD[0].AOR_NONTAX.toString() != ''
                                    ? slipRow(
                                    'AOR_NONTAX', PSD[0].AOR_NONTAX.toString())
                                    : SizedBox(),
                                PSD[0].POSTAL_RELIEF_FUND.toString() != ''
                                    ? slipRow('POSTAL_RELIEF_FUND',
                                    PSD[0].POSTAL_RELIEF_FUND.toString())
                                    : SizedBox(),
                                PSD[0].PLI_PREMIUM.toString() != ''
                                    ? slipRow(
                                    'PLI_PREMIUM', PSD[0].PLI_PREMIUM.toString())
                                    : SizedBox(),
                                PSD[0].RECREATION_CLUB.toString() != ''
                                    ? slipRow('RECREATION_CLUB',
                                    PSD[0].RECREATION_CLUB.toString())
                                    : SizedBox(),
                                PSD[0].UNION_ASSOCIATION.toString() != ''
                                    ? slipRow('UNION_ASSOCIATION',
                                    PSD[0].UNION_ASSOCIATION.toString())
                                    : SizedBox(),
                                PSD[0].WELFARE_FUND.toString() != '' ? slipRow(
                                    'WELFARE_FUND',
                                    PSD[0].WELFARE_FUND.toString()) : SizedBox(),
                                PSD[0].CGEGIS.toString() != ''
                                    ? slipRow('CGEGIS', PSD[0].CGEGIS.toString())
                                    : SizedBox(),
                                PSD[0].CGHS.toString() != '' ? slipRow(
                                    'CGHS', PSD[0].CGHS.toString()) : SizedBox(),
                                PSD[0].EDAGIS_92.toString() != ''
                                    ? slipRow(
                                    'EDAGIS_92', PSD[0].EDAGIS_92.toString())
                                    : SizedBox(),
                                PSD[0].LIC_PREMIUM.toString() != ''
                                    ? slipRow(
                                    'LIC_PREMIUM', PSD[0].LIC_PREMIUM.toString())
                                    : SizedBox(),
                                PSD[0].CGIS.toString() != '' ? slipRow(
                                    'CGIS', PSD[0].CGIS.toString()) : SizedBox(),
                                PSD[0].RPLI.toString() != '' ? slipRow(
                                    'RPLI', PSD[0].RPLI.toString()) : SizedBox(),
                                PSD[0].PLI_SERVICE_TAX.toString() != ''
                                    ? slipRow('PLI_SERVICE_TAX',
                                    PSD[0].PLI_SERVICE_TAX.toString())
                                    : SizedBox(),
                                PSD[0].CONNECTIONS.toString() != ''
                                    ? slipRow(
                                    'CONNECTIONS', PSD[0].CONNECTIONS.toString())
                                    : SizedBox(),
                                PSD[0].CGEWCC.toString() != ''
                                    ? slipRow('CGEWCC', PSD[0].CGEWCC.toString())
                                    : SizedBox(),
                                PSD[0].SOCIETIES.toString() != ''
                                    ? slipRow(
                                    'SOCIETIES', PSD[0].SOCIETIES.toString())
                                    : SizedBox(),
                                PSD[0].FNPO.toString() != '' ? slipRow(
                                    'FNPO', PSD[0].FNPO.toString()) : SizedBox(),
                                PSD[0].ED_GIS.toString() != ''
                                    ? slipRow('ED_GIS', PSD[0].ED_GIS.toString())
                                    : SizedBox(),
                                PSD[0].SECURITY_BONDS.toString() != ''
                                    ? slipRow('SECURITY_BONDS',
                                    PSD[0].SECURITY_BONDS.toString())
                                    : SizedBox(),
                                PSD[0].EXTRA_DEPARTMENTAL_UNIONS.toString() != ''
                                    ? slipRow('EXTRA_DEPARTMENTAL_UNIONS',
                                    PSD[0].EXTRA_DEPARTMENTAL_UNIONS.toString())
                                    : SizedBox(),
                                PSD[0].CGEGIS_INSURANCE_FUND.toString() != ''
                                    ? slipRow('CGEGIS_INSURANCE_FUND',
                                    PSD[0].CGEGIS_INSURANCE_FUND.toString())
                                    : SizedBox(),
                                PSD[0].POSTAL_COOP_SOCIETY.toString() != ''
                                    ? slipRow('POSTAL_COOP_SOCIETY',
                                    PSD[0].POSTAL_COOP_SOCIETY.toString())
                                    : SizedBox(),
                                PSD[0].COOP_BANK_REC.toString() != '' ? slipRow(
                                    'COOP_BANK_REC',
                                    PSD[0].COOP_BANK_REC.toString()) : SizedBox(),
                                PSD[0].DIVISION_SPORTS_BOARD.toString() != ''
                                    ? slipRow('DIVISION_SPORTS_BOARD',
                                    PSD[0].DIVISION_SPORTS_BOARD.toString())
                                    : SizedBox(),
                                PSD[0].MISC_DEDUCTIONS.toString() != ''
                                    ? slipRow('MISC_DEDUCTIONS',
                                    PSD[0].MISC_DEDUCTIONS.toString())
                                    : SizedBox(),
                                PSD[0].BONDS.toString() != ''
                                    ? slipRow('BONDS', PSD[0].BONDS.toString())
                                    : SizedBox(),
                                PSD[0].CWFGDS.toString() != ''
                                    ? slipRow('CWFGDS', PSD[0].CWFGDS.toString())
                                    : SizedBox(),
                                PSD[0].FESTIVAL_ADVANCE_SPECIAL.toString() != ''
                                    ? slipRow('FESTIVAL_ADVANCE_SPECIAL',
                                    PSD[0].FESTIVAL_ADVANCE_SPECIAL.toString())
                                    : SizedBox(),
                                PSD[0].TOTAL_DEDUCTIONS.toString() != ''
                                    ? slipRow('TOTAL_DEDUCTIONS',
                                    PSD[0].TOTAL_DEDUCTIONS.toString())
                                    : SizedBox(),
                                PSD[0].TOTAL_GROSS_AMOUNT.toString() != ''
                                    ? slipRow('TOTAL_GROSS_AMOUNT',
                                    PSD[0].TOTAL_GROSS_AMOUNT.toString())
                                    : SizedBox(),
                                PSD[0].NET_PAY.toString() != ''
                                    ? slipRow(
                                    'NET_PAY', PSD[0].NET_PAY.toString())
                                    : SizedBox(),

                                //  slipRow('Employee ID', PSD[0].EMPLOYEE_ID.toString()),
                                //  slipRow('Employee Name',PSD[0].EMPLOYEE_NAME.toString()),
                                //  slipRow('Location','Hosamagalai BO'),
                                //  slipRow('Position', 'GDS Branch Post Master'),
                                // PSD[0].BOAT_ALLOWANCE.toString()!=''? slipRow('Account No.', '3106704957'):SizedBox(),
                                //  slipRow('TR Continuity Allowance', '4745'),
                                //  slipRow('Dearness Allowance', '6596'),
                                //  slipRow('Total Earnings', '11341'),
                                //  slipRow('Total Gross Amount', '11341'),
                                //  slipRow('Net Pay', '11341.00'),
                              ],
                            ),
                          ),
                        ),
                        Button(buttonText: 'PRINT', buttonFunction: () async {
                          List<String> PSDInfo = <String>[];

                          if(PSD[0].EMPLOYEE_ID.toString()!='')
                          {
                            PSDInfo.add('EMPLOYEE_ID');
                            PSDInfo.add(PSD[0].EMPLOYEE_ID.toString());
                          }
                          if(PSD[0].EMPLOYEE_NAME.toString()!='')
                          {
                            PSDInfo.add('EMPLOYEE_NAME');
                            PSDInfo.add(PSD[0].EMPLOYEE_NAME.toString());
                          }
                         if(PSD[0].OFFICE.toString()!=''){PSDInfo.add('OFFICE');PSDInfo.add(PSD[0].OFFICE.toString());}
                         if(PSD[0].POSITION.toString()!=''){PSDInfo.add('POSITION');PSDInfo.add(PSD[0].POSITION.toString());}
                         if(PSD[0].MONTH.toString()!=''){PSDInfo.add('MONTH');PSDInfo.add(PSD[0].MONTH.toString());}
                         if(PSD[0].YEAR.toString()!=''){PSDInfo.add('YEAR');PSDInfo.add(PSD[0].YEAR.toString());}
                         if(PSD[0].ACCOUNT_NUMBER.toString()!=''){PSDInfo.add('ACCOUNT_NUMBER');PSDInfo.add(PSD[0].ACCOUNT_NUMBER.toString());}
                         if(PSD[0].TRCA.toString()!=''){PSDInfo.add('TRCA');PSDInfo.add(PSD[0].TRCA.toString());}
                          if(PSD[0].DEARNESS_ALLOWANCE.toString()!=''){PSDInfo.add('DEARNESS_ALLOWANCE');PSDInfo.add(PSD[0].DEARNESS_ALLOWANCE.toString());}
                         if(PSD[0].FIXED_STATIONERY_CHARGES.toString()!=''){PSDInfo.add('FIXED_STATIONERY_CHARGES');PSDInfo.add(PSD[0].FIXED_STATIONERY_CHARGES.toString());}
                          if(PSD[0].BOAT_ALLOWANCE.toString()!=''){PSDInfo.add('BOAT_ALLOWANCE');PSDInfo.add(PSD[0].BOAT_ALLOWANCE.toString());}
                          if(PSD[0].CYCLE_MAINTENANCE_ALLOWANCE.toString()!=''){PSDInfo.add('CYCLE_MAINTENANCE_ALLOWANCE');PSDInfo.add(PSD[0].CYCLE_MAINTENANCE_ALLOWANCE.toString());}
                          if(PSD[0].OFFICE_MAINTENANCE_ALLOWANCE.toString()!=''){PSDInfo.add('OFFICE_MAINTENANCE_ALLOWANCE');PSDInfo.add(PSD[0].OFFICE_MAINTENANCE_ALLOWANCE.toString());}
                          if(PSD[0].CDA.toString()!=''){PSDInfo.add('CDA');PSDInfo.add(PSD[0].CDA.toString());}
                          if(PSD[0].COMBINATION_DELIVERY_ALLOWANCE.toString()!=''){PSDInfo.add('COMBINATION_DELIVERY_ALLOWANCE');PSDInfo.add(PSD[0].COMBINATION_DELIVERY_ALLOWANCE.toString());}
                          if(PSD[0].COMPENSATION_MAIL_CARRIER.toString()!=''){PSDInfo.add('COMPENSATION_MAIL_CARRIER');PSDInfo.add(PSD[0].COMPENSATION_MAIL_CARRIER.toString());}
                          if(PSD[0].RETAINERSHIP_ALLOWANCE.toString()!=''){PSDInfo.add('RETAINERSHIP_ALLOWANCE');PSDInfo.add(PSD[0].RETAINERSHIP_ALLOWANCE.toString());}
                          if(PSD[0].CASH_CONVEYANCE_ALLOWANCE.toString()!=''){PSDInfo.add('CASH_CONVEYANCE_ALLOWANCE');PSDInfo.add(PSD[0].CASH_CONVEYANCE_ALLOWANCE.toString());}
                          if(PSD[0].PERSONAL_ALLOWANCE_GDS.toString()!=''){PSDInfo.add('PERSONAL_ALLOWANCE_GDS');PSDInfo.add(PSD[0].PERSONAL_ALLOWANCE_GDS.toString());}
                          if(PSD[0].BONUS_GDS.toString()!=''){PSDInfo.add('BONUS_GDS');PSDInfo.add(PSD[0].BONUS_GDS.toString());}
                          if(PSD[0].EXGRATIA_GRATUITY.toString()!=''){PSDInfo.add('EXGRATIA_GRATUITY');PSDInfo.add(PSD[0].EXGRATIA_GRATUITY.toString());}
                          if(PSD[0].SEVERANCE_AMOUNT.toString()!=''){PSDInfo.add('SEVERANCE_AMOUNT');PSDInfo.add(PSD[0].SEVERANCE_AMOUNT.toString());}
                          if(PSD[0].INCENTIVES.toString()!=''){PSDInfo.add('INCENTIVES');PSDInfo.add(PSD[0].INCENTIVES.toString());}
                          if(PSD[0].DA_ARREARS_GDS.toString()!=''){PSDInfo.add('DA_ARREARS_GDS');PSDInfo.add(PSD[0].DA_ARREARS_GDS.toString());}
                          if(PSD[0].TOTAL_EARNINGS.toString()!=''){PSDInfo.add('TOTAL_EARNINGS');PSDInfo.add(PSD[0].TOTAL_EARNINGS.toString());}
                          if(PSD[0].TRCA_ALLOWANCE_ARREARS.toString()!=''){PSDInfo.add('TRCA_ALLOWANCE_ARREARS');PSDInfo.add(PSD[0].TRCA_ALLOWANCE_ARREARS.toString());}
                          if(PSD[0].DEARNESS_ALLOWANCE_ARREAR.toString()!=''){PSDInfo.add('DEARNESS_ALLOWANCE_ARREAR');PSDInfo.add(PSD[0].DEARNESS_ALLOWANCE_ARREAR.toString());}
                          if(PSD[0].DEARNESS_RELIEF_CDAARREAR.toString()!=''){PSDInfo.add('DEARNESS_RELIEF_CDAARREAR');PSDInfo.add(PSD[0].DEARNESS_RELIEF_CDAARREAR.toString());}
                          if(PSD[0].TOTAL_ARREARS.toString()!=''){PSDInfo.add('TOTAL_ARREARS');PSDInfo.add(PSD[0].TOTAL_ARREARS.toString());}
                          if(PSD[0].COURT_ATTACHMENT_ODFM.toString()!=''){PSDInfo.add('COURT_ATTACHMENT_ODFM');PSDInfo.add(PSD[0].COURT_ATTACHMENT_ODFM.toString());}
                          if(PSD[0].RD.toString()!=''){PSDInfo.add('RD');PSDInfo.add(PSD[0].RD.toString());}
                          if(PSD[0].COURT_ATTACHMENT_DFM.toString()!=''){PSDInfo.add('COURT_ATTACHMENT_DFM');PSDInfo.add(PSD[0].COURT_ATTACHMENT_DFM.toString());}
                          if(PSD[0].LICENSE_FEE.toString()!=''){PSDInfo.add('LICENSE_FEE');PSDInfo.add(PSD[0].LICENSE_FEE.toString());}
                          if(PSD[0].SDBS.toString()!=''){PSDInfo.add('SDBS');PSDInfo.add(PSD[0].SDBS.toString());}
                          if(PSD[0].AUDIT_OFFICE_RECOVERY.toString()!=''){PSDInfo.add('AUDIT_OFFICE_RECOVERY');PSDInfo.add(PSD[0].AUDIT_OFFICE_RECOVERY.toString());}
                          if(PSD[0].COOP_CREDIT_SOCIETY.toString()!=''){PSDInfo.add('COOP_CREDIT_SOCIETY');PSDInfo.add(PSD[0].COOP_CREDIT_SOCIETY.toString());}
                          if(PSD[0].RELIEF_FUND.toString()!=''){PSDInfo.add('RELIEF_FUND');PSDInfo.add(PSD[0].RELIEF_FUND.toString());}
                          if(PSD[0].DEATH_RELIEF_FUND.toString()!=''){PSDInfo.add('DEATH_RELIEF_FUND');PSDInfo.add(PSD[0].DEATH_RELIEF_FUND.toString());}
                          if(PSD[0].WATER_TAX.toString()!=''){PSDInfo.add('WATER_TAX');PSDInfo.add(PSD[0].WATER_TAX.toString());}
                          if(PSD[0].ELECTRICITY_CHARGES.toString()!=''){PSDInfo.add('ELECTRICITY_CHARGES');PSDInfo.add(PSD[0].ELECTRICITY_CHARGES.toString());}
                          if(PSD[0].AOR_NONTAX.toString()!=''){PSDInfo.add('AOR_NONTAX');PSDInfo.add(PSD[0].AOR_NONTAX.toString());}
                          if(PSD[0].POSTAL_RELIEF_FUND.toString()!=''){PSDInfo.add('POSTAL_RELIEF_FUND');PSDInfo.add(PSD[0].POSTAL_RELIEF_FUND.toString());}
                          if(PSD[0].PLI_PREMIUM.toString()!=''){PSDInfo.add('PLI_PREMIUM');PSDInfo.add(PSD[0].PLI_PREMIUM.toString());}
                          if(PSD[0].RECREATION_CLUB.toString()!=''){PSDInfo.add('RECREATION_CLUB');PSDInfo.add(PSD[0].RECREATION_CLUB.toString());}
                          if(PSD[0].UNION_ASSOCIATION.toString()!=''){PSDInfo.add('UNION_ASSOCIATION');PSDInfo.add(PSD[0].UNION_ASSOCIATION.toString());}
                          if(PSD[0].WELFARE_FUND.toString()!=''){PSDInfo.add('WELFARE_FUND');PSDInfo.add(PSD[0].WELFARE_FUND.toString());}
                          if(PSD[0].CGEGIS.toString()!=''){PSDInfo.add('CGEGIS');PSDInfo.add(PSD[0].CGEGIS.toString());}
                          if(PSD[0].CGHS.toString()!=''){PSDInfo.add('CGHS');PSDInfo.add(PSD[0].CGHS.toString());}
                          if(PSD[0].EDAGIS_92.toString()!=''){PSDInfo.add('EDAGIS_92');PSDInfo.add(PSD[0].EDAGIS_92.toString());}
                          if(PSD[0].LIC_PREMIUM.toString()!=''){PSDInfo.add('LIC_PREMIUM');PSDInfo.add(PSD[0].LIC_PREMIUM.toString());}
                          if(PSD[0].CGIS.toString()!=''){PSDInfo.add('CGIS');PSDInfo.add(PSD[0].CGIS.toString());}
                          if(PSD[0].RPLI.toString()!=''){PSDInfo.add('RPLI');PSDInfo.add(PSD[0].RPLI.toString());}
                          if(PSD[0].PLI_SERVICE_TAX.toString()!=''){PSDInfo.add('PLI_SERVICE_TAX');PSDInfo.add(PSD[0].PLI_SERVICE_TAX.toString());}
                          if(PSD[0].CONNECTIONS.toString()!=''){PSDInfo.add('CONNECTIONS');PSDInfo.add(PSD[0].CONNECTIONS.toString());}
                          if(PSD[0].CGEWCC.toString()!=''){PSDInfo.add('CGEWCC');PSDInfo.add(PSD[0].CGEWCC.toString());}
                          if(PSD[0].SOCIETIES.toString()!=''){PSDInfo.add('SOCIETIES');PSDInfo.add(PSD[0].SOCIETIES.toString());}
                          if(PSD[0].FNPO.toString()!=''){PSDInfo.add('FNPO');PSDInfo.add(PSD[0].FNPO.toString());}
                          if(PSD[0].ED_GIS.toString()!=''){PSDInfo.add('ED_GIS');PSDInfo.add(PSD[0].ED_GIS.toString());}
                          if(PSD[0].SECURITY_BONDS.toString()!=''){PSDInfo.add('SECURITY_BONDS');PSDInfo.add(PSD[0].SECURITY_BONDS.toString());}
                          if(PSD[0].EXTRA_DEPARTMENTAL_UNIONS.toString()!=''){PSDInfo.add('EXTRA_DEPARTMENTAL_UNIONS');PSDInfo.add(PSD[0].EXTRA_DEPARTMENTAL_UNIONS.toString());}
                          if(PSD[0].CGEGIS_INSURANCE_FUND.toString()!=''){PSDInfo.add('CGEGIS_INSURANCE_FUND');PSDInfo.add(PSD[0].CGEGIS_INSURANCE_FUND.toString());}
                          if(PSD[0].POSTAL_COOP_SOCIETY.toString()!=''){PSDInfo.add('POSTAL_COOP_SOCIETY');PSDInfo.add(PSD[0].POSTAL_COOP_SOCIETY.toString());}
                          if(PSD[0].COOP_BANK_REC.toString()!=''){PSDInfo.add('COOP_BANK_REC');PSDInfo.add(PSD[0].COOP_BANK_REC.toString());}
                          if(PSD[0].DIVISION_SPORTS_BOARD.toString()!=''){PSDInfo.add('DIVISION_SPORTS_BOARD');PSDInfo.add(PSD[0].DIVISION_SPORTS_BOARD.toString());}
                          if(PSD[0].MISC_DEDUCTIONS.toString()!=''){PSDInfo.add('MISC_DEDUCTIONS');PSDInfo.add(PSD[0].MISC_DEDUCTIONS.toString());}
                          if(PSD[0].BONDS.toString()!=''){PSDInfo.add('BONDS');PSDInfo.add(PSD[0].BONDS.toString());}
                          if(PSD[0].CWFGDS.toString()!=''){PSDInfo.add('CWFGDS');PSDInfo.add(PSD[0].CWFGDS.toString());}
                          if(PSD[0].FESTIVAL_ADVANCE_SPECIAL.toString()!=''){PSDInfo.add('FESTIVAL_ADVANCE_SPECIAL');PSDInfo.add(PSD[0].FESTIVAL_ADVANCE_SPECIAL.toString());}
                          if(PSD[0].TOTAL_DEDUCTIONS.toString()!=''){PSDInfo.add('TOTAL_DEDUCTIONS');PSDInfo.add(PSD[0].TOTAL_DEDUCTIONS.toString());}
                          if(PSD[0].TOTAL_GROSS_AMOUNT.toString()!=''){PSDInfo.add('TOTAL_GROSS_AMOUNT');PSDInfo.add(PSD[0].TOTAL_GROSS_AMOUNT.toString());}
                          if(PSD[0].NET_PAY.toString()!=''){PSDInfo.add('NET_PAY');PSDInfo.add(PSD[0].NET_PAY.toString());}

                          PrintingTelPO printer = new PrintingTelPO();
                          bool value =
                              await printer.printThroughUsbPrinter(
                              "Utilities",
                              "Pay Slip",
                                  PSDInfo,
                                  PSDInfo,
                              1);
                        })
                      ],
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Widget slipRow(String title, String description) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  title,
                  style: TextStyle(letterSpacing: 1),
                ),
              )),
          SizedBox(width: 15, child: Text(':')),
          Expanded(
              flex: 1,
              child: Text(
                description,
                style: TextStyle(letterSpacing: 1, fontWeight: FontWeight.w500),
              )),
        ],
      ),
    );
  }
}
