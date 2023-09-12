import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
part 'tempInsurance.g.dart';

const officeModel = SqfEntityTable(
    tableName: 'officeDetails',
    primaryKeyName: 'SNo',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('BOOFFICETYPE', DbType.text),
      SqfEntityField('dateTime', DbType.text),
      SqfEntityField('BOOFFICECODE', DbType.text),
      SqfEntityField('COOFFICETYPE', DbType.text),
      SqfEntityField('HOOFFICEADDRESS', DbType.text),
      SqfEntityField('HOOFFICECODE', DbType.text),
      SqfEntityField('HOOFFICETYPE', DbType.text),
      SqfEntityField('BOOFFICEADDRESS', DbType.text),
      SqfEntityField('OFFICECODE_6', DbType.text),
      SqfEntityField('OFFICECODE_4', DbType.text),
      SqfEntityField('OFFICECODE_5', DbType.text),
      SqfEntityField('OFFICECODE_2', DbType.text),
      SqfEntityField('OFFICECODE_3', DbType.text),
      SqfEntityField('OFFICECODE_1', DbType.text),
      SqfEntityField('POCode', DbType.text),
      SqfEntityField('OFFICETYPE_3', DbType.text),
      SqfEntityField('OFFICEADDRESS_4', DbType.text),
      SqfEntityField('OFFICEADDRESS_3', DbType.text),
      SqfEntityField('OFFICETYPE_4', DbType.text),
      SqfEntityField('OFFICETYPE_1', DbType.text),
      SqfEntityField('OFFICEADDRESS_6', DbType.text),
      SqfEntityField('OFFICETYPE_2', DbType.text),
      SqfEntityField('OFFICEADDRESS_5', DbType.text),
      SqfEntityField('COOFFICEADDRESS', DbType.text),
      SqfEntityField('OFFICEADDRESS_2', DbType.text),
      SqfEntityField('OFFICETYPE_5', DbType.text),
      SqfEntityField('COOFFICECODE', DbType.text),
      SqfEntityField('OFFICEADDRESS_1', DbType.text),
      SqfEntityField('OFFICETYPE_6', DbType.text),
    ]);

// const inspolicy = SqfEntityTable(
//     tableName: 'policyDetails',
//     primaryKeyName: 'SNo',
//     primaryKeyType: PrimaryKeyType.integer_auto_incremental,
//       fields:[
//             SqfEntityField('carrid',DbType.text),
//             SqfEntityField('INIT_CGSTPER',DbType.text),
//             SqfEntityField('freq',DbType.text),
//             SqfEntityField('Init_CGST',DbType.text),
//             SqfEntityField('premiumrebate',DbType.text),
//             SqfEntityField('DateTime',DbType.text),
//             SqfEntityField('taxtype',DbType.text),
//             SqfEntityField('RENEWAL_CGSTPER',DbType.text),
//             SqfEntityField('totalamt',DbType.text),
//             SqfEntityField('premiumintrest',DbType.text),
//             SqfEntityField('premiumdueamt',DbType.text),
//             SqfEntityField('balamt',DbType.text),
//             SqfEntityField('srvtaxtotamt',DbType.text),
//             SqfEntityField('Status',DbType.text),
//             SqfEntityField('agentid',DbType.text),
//             SqfEntityField('paidtodate',DbType.text),
//             SqfEntityField('Init_SGST',DbType.text),
//             SqfEntityField('RENEWAL_SGSTPER',DbType.text),
//             SqfEntityField('Init_UGST',DbType.text),
//             SqfEntityField('INIT_UGSTPER',DbType.text),
//             SqfEntityField('op_GSTrenewalyr',DbType.text),
//             SqfEntityField('INIT_SGSTPER',DbType.text),
//             SqfEntityField('RENEWAL_UGSTPER',DbType.text),
//             SqfEntityField('Renewal_CGST',DbType.text),
//             SqfEntityField('intialAmount',DbType.text),
//             SqfEntityField('Renewal_SGST',DbType.text),
//             SqfEntityField('op_GSTinityr',DbType.text),
//             SqfEntityField('policyname',DbType.text),
//             SqfEntityField('billtodate',DbType.text),
//             SqfEntityField('Renewal_UGST',DbType.text),
//             SqfEntityField('Gstnumber',DbType.text),
//             SqfEntityField('renewalAmount',DbType.text),
//       ]
// );

@SqfEntityBuilder(reportModel)
const reportModel = SqfEntityModel(
    modelName: 'officeDetails',
    password: 'lbTSj1*W)i@oWq',
    databaseName: 'office.db',
    databaseTables: [officeModel]);
